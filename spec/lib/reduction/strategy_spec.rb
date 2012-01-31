require 'spec_helper'

module Reduction

  describe Strategy do

    let(:page_url)  { 'http://www.example.com/' }
    let(:page_html) { '<html><body>foo</body></html>' }
    subject { described_class.new(page_html, page_url) }

    METHODS = %w[title ingredients steps yields prep_time cook_time total_time for_url?]

    it 'has a high priority' do
      described_class.priority.should == 1
    end

    describe '#url' do
      it 'is the URL passed in to the contructor' do
        subject.url.should == page_url
      end

      it 'is aliased to source_url' do
        subject.source_url.should == subject.url
      end
    end

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
        described_class.subclasses.should =~ described_class.all
      end

      it 'orders the subclasses by priority' do
        described_class.all.should_not be_empty
        described_class.all.inject(0) do |priority, strategy|
          strategy.priority.should be >= priority
          strategy.priority
        end
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

    describe '.reduce' do

      let(:body) { 'body' }
      let(:url) { 'url' }
      let(:instance) { described_class.new(body, url) }

      before(:each) { described_class.reduce(:yields, &Proc.new {}) }

      it 'creates an instance method with the same name' do
        instance.should respond_to(:yields)
      end

      it 'makes the block body the method' do
        described_class.reduce(:yields, &Proc.new { 'hello' })
        instance.yields.should == 'hello'
      end

      it 'catches any exceptions and returns none' do
         described_class.reduce(:yields, &Proc.new { raise 'boom!' })
         instance.yields.should be_nil
      end

      context 'when passed a default option' do

        before(:each) do
          described_class.reduce(:yields, :default => 'default val') do
            raise 'boom!'
          end
        end

        it 'catches the exception and returns the default instead' do
          instance.yields.should == 'default val'
        end

      end

    end

  end

end