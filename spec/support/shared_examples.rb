shared_examples_for "a strategy" do

  string_methods = %w[title yields]
  list_methods = %w[ingredients steps]
  array_methods = %w[images]
  all_methods = string_methods + list_methods + array_methods

  all_methods.each do |method|

    it "should not raise an exeption when calling ##{method}" do
      expect {
        subject.send(method)
      }.to_not raise_exception
    end

  end

  string_methods.each do |method|
    it "should return a string for ##{method}" do
      subject.send(method).should be_a(String)
    end
  end

  list_methods.each do |method|
    it "should return an array of objects that respond to :each ##{method}" do
      subject.send(method).each do |element|
        element.should respond_to(:each)
      end
    end

    it "should return an array of objects that respond to :name" do
      subject.send(method).each do |element|
        element.should respond_to(:name)
      end
    end
  end

  array_methods.each do |method|
    it "#{method} return an object that responds to each" do
      subject.send(method).should respond_to(:each)
    end
  end

  it 'should not raise an exception when calling for_url?' do
    expect {
      described_class.for_url?('foo')
    }.to_not raise_exception
  end

end


%w[title ingredients steps yields prep_time cook_time total_time images].each do |method|
  shared_examples_for "#{method}" do |property|
    it "should return the correct #{method}" do
      subject.send(method).should == property
    end
  end
end