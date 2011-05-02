require 'spec_helper'

module Reduction

  describe Strategy do

    let(:page_html) { '<html><body>foo</body></html>' }
    subject { described_class.new(page_html) }

    describe '#doc' do

      it 'is a nokogiri doc' do
        subject.doc.should be_a(Nokogiri::HTML::Document)
      end

      it 'is the doc for the passed in string' do
        subject.doc.text.should == 'foo'
      end

    end

    %w[title ingredients steps yields prep_time cook_time].each do |method|
      describe "##{method}" do
        it 'raises a runtime exception' do
          expect {
            subject.send(method)
          }.to raise_exception(RuntimeError, /not implemented/)
        end
      end
    end

  end

end