require 'spec_helper'

module Reduction

  describe NamedList do

    subject { described_class.new }

    it 'is a array' do
      subject.should be_a(Array)
    end

    it 'has a name attribute that can be set and read from' do
      subject.name.should be_nil
      subject.name = 'Steve'
      subject.name.should == 'Steve'
    end

    describe '.from_node_set' do

      let(:doc) do
        <<-EOF
        <div>
          <h4>Title 1</h4>
          <ul><li>Item 1</li><li>Item 2</li></ul>
          <h4>Title 2</h4>
          <ul><li>Item 3</li><li>Item 4</li></ul>
        </div>
        EOF
      end

      let(:container) { Nokogiri::XML(doc).at('div') }
      let(:nodeset) { container.children }

      subject { described_class.from_node_set(nodeset, :h4) }

      it 'returns an array of NamedList documents' do
        subject.each do |item|
          item.should be_a(NamedList)
        end
      end

      it 'takes the every other element, starting with the first, as the name of the list' do
        subject.map(&:name).should == ['Title 1', 'Title 2']
      end

      it 'takes every other item, starting with the 2nd, as the list' do
        subject[0].should == ['Item 1', 'Item 2']
        subject[1].should == ['Item 3', 'Item 4']
      end

      it 'allows you to use a different title element name' do
        nodeset.search('h4').each { |e| e.name = 'h5' }
        described_class.from_node_set(nodeset, :h4).should be_empty

        list = described_class.from_node_set(nodeset, :h5)
        list.map(&:name).should == ['Title 1', 'Title 2']
      end

      it 'finds lists that have no title' do
        container.add_child('<ul><li>bogus</li></ul>')
        nodeset.search('ul').should have(3).elements
        subject[0].should == ['Item 1', 'Item 2']
        subject[1].should == ['Item 3', 'Item 4']
        subject[2].should == ['bogus']
      end
    end

  end

end
