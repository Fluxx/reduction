require 'spec_helper'

module Reduction

  describe Strategy do

    let(:page_url)  { 'http://www.example.com/' }
    let(:page_html) { '<html><body>foo</body></html>' }
    subject { described_class.new(page_html, page_url) }

    METHODS = %w[title ingredients steps yields prep_time cook_time total_time for_url?]

    describe '#doc' do

      it 'is a nokogiri doc' do
        subject.doc.should be_a(Nokogiri::HTML::Document)
      end

      it 'is the doc for the passed in string' do
        subject.doc.text.should == 'foo'
      end

    end

    (METHODS - %w[for_url? title]).each do |method|
      describe "##{method}" do
        it 'raises a runtime exception' do
          expect {
            subject.send(method)
          }.to raise_exception(RuntimeError, /not implemented/)
        end
      end
    end

    describe 'body' do
      before(:each) do
        METHODS.each do |method|
          subject.stub(method => (method + '-value'))
        end
      end

      it 'lists all the other fields' do
        subject.body.should == <<-BODY.chomp
Ingredients: ingredients-value
Steps: steps-value
Prep Time: prep_time-value
Cook Time: cook_time-value
Total Time: total_time-value
Yields: yields-value
BODY
      end
    end

    describe '.all' do

      it 'returns all subclasses inside the Strategy namespace' do
        described_class.subclasses.should == described_class.all
      end

    end

    describe '.for_url' do

      let(:supported) { described_class.all.first }
      let(:url)       { 'example_url' }

      it 'returns the strategy for the specified URL' do
        supported.should_receive(:for_url?).with(url).and_return(true)
        described_class.for_url(url).should == supported
      end

      it 'returns nil if the URL is not a URL' do
        described_class.for_url('junk').should be_nil
      end

      it 'returns the general strategy for non-hand picke URLs' do
        described_class.for_url('http://google.com').should == described_class::General
      end

    end

  end

end