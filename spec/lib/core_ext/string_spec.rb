require 'spec_helper'

describe String, '#stripped_lines' do

  it 'returns an array of lines from the string' do
    "foo\nbar".stripped_lines.should == ['foo', 'bar']
  end

  it 'does not return empty lines' do
    "champagne\n\t\nvinegar".stripped_lines.should == ['champagne', 'vinegar']
  end

  it 'strips leading and trailing whitespace from the string' do
    "\t\ttop\nchef".stripped_lines.should == ['top', 'chef']
  end

  it 'return an empty array for an empty string' do
    "".stripped_lines.should == []
  end

end