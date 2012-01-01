require 'spec_helper'

module Reduction

  describe NamedList do

    subject { described_class.new [ ['1', '2'], '3'] }

    it 'can be YAML dumped' do
      dumped = YAML.dump(subject)
      loaded = YAML.load(dumped)
      loaded.to_a.should == subject.to_a
      loaded.name.should == subject.name
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

      it 'collapses the whitespace for title elements' do
        container.at('h4').replace("<h4>\nMessed\n\rUp    \r</h4>")
        subject.map(&:name).first.should == 'Messed Up'
      end

      it 'collapses the whitespace for each list item' do
        container.add_child("<ul><li>\n\nmessed\t\r  up   \t\t\t\r  \t</li></ul>")
        subject[2].should == ['messed up']
      end

      it 'takes every other item, starting with the 2nd, as the list' do
        subject[0].should == ['Item 1', 'Item 2']
        subject[1].should == ['Item 3', 'Item 4']
      end

      it 'allows you to use a different title element name' do
        nodeset.search('h4').each { |e| e.name = 'h5' }
        set = described_class.from_node_set(nodeset, :h4)
        set[0].should == ['Item 1', 'Item 2']
        set[1].should == ['Item 3', 'Item 4']

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

      context 'when there are different types of title elements' do
        before(:each) do
          container.at('h4').replace("<h3>An H3 title</h3>")
        end

        subject { described_class.from_node_set(nodeset, :h4, :h3) }

        it 'finds them by passing extra title element arguments' do
          subject.map(&:name).should == ['An H3 title', 'Title 2']
        end

      end
    end

    describe 'json serialization' do

      let(:example_1) do
        described_class.new.tap do |l|
          l.name = 'example list'
          l << 1
          l << 'a'
        end
      end

      let(:example_2) do
        described_class.new.tap do |l|
          l.name = 'second list'
          l << 2
          l << 3.1415
        end
      end

      let(:both) { [example_1, example_2] }

      def encoded(obj)
        MultiJson.encode(obj)
      end

      def decoded(str)
        MultiJson.decode(str)
      end

      it 'can be serialized and de-serialized' do
        round_trip = decoded(encoded(example_1))
        round_trip.should == example_1
        round_trip.name.should == 'example list'
      end

      it 'works if there is an array of named lists' do
        round_trip = decoded(encoded(both))
        round_trip.should == both
        round_trip.last.should == example_2
        round_trip.last.name.should == 'second list'
      end

    end

  end

end
