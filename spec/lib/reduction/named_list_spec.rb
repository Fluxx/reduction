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

  end

end
