shared_examples_for "a strategy" do

  string_methods = %w[title yields]
  array_methods = %w[ingredients steps]
  all_methods = string_methods + array_methods

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

  array_methods.each do |method|
    it "should return an array of arrays for ##{method}" do
      subject.send(method).should be_a(Array)
      subject.send(method).each do |element|
        element.should be_a(Array)
      end
    end
  end

  it 'should not raise an exception when calling for_url?' do
    expect {
      described_class.for_url?('foo')
    }.to_not raise_exception
  end

end


%w[title ingredients steps yields prep_time cook_time total_time].each do |method|
  shared_examples_for "#{method}" do |property|
    it "should return the correct #{method}" do
      subject.send(method).should == property
    end
  end
end