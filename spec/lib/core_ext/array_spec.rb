require 'spec_helper'

describe Array, '#clean!' do

  it 'calls #collapse_whitespace! on each item' do
    arr = [mock(:collapse_whitespace => 'foo'), mock(:collapse_whitespace => 'bar')]
    arr.clean!
    arr.should == %w[foo bar]
  end

  it 'removes any empty elements' do
    arr = ['only', 'whitespace', "\n\r"]
    arr.clean!
    arr.should == ['only', 'whitespace']
  end

end