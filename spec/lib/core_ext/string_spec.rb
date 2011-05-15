# encoding: UTF-8

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

describe String, '#collapse_whitespace' do

  it 'removes trailing and leading whitespace' do
    "\nhello".collapse_whitespace.should == 'hello'
    "world\t".collapse_whitespace.should == 'world'
    "\n\rfoo".collapse_whitespace.should == 'foo'
    '  big papa  '.collapse_whitespace.should == 'big papa'
  end

  it 'collapses whitespace in between word characters to a single space' do
    'hello      world'.collapse_whitespace.should == 'hello world'
    "hello\n\rworld".collapse_whitespace.should == 'hello world'
    "hello \nworld".collapse_whitespace.should == 'hello world'
  end

  it 'does not remove non-word characters' do
    'hash-dash'.should == 'hash-dash'
    '1/2'.should == '1/2'
    '6º degrees of kevin bacon'.should == '6º degrees of kevin bacon'
  end


end