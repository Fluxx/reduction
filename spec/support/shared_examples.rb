shared_examples_for "a strategy" do |type|

  string_methods = %w[title yields notes prep_time cook_time total_time body]
  list_methods = %w[ingredients steps]
  array_methods = %w[images]
  all_methods = string_methods + list_methods + array_methods

  all_methods.each do |method|

    it "does not raise an exeption when calling ##{method}" do
      expect {
        subject.send(method)
      }.to_not raise_exception
    end

  end

  %w[title yields].each do |method|
    it "returns a string for ##{method}" do
      subject.send(method).should be_a(String)
    end
  end

  list_methods.each do |method|
    it "returns an array of objects that respond to :each ##{method}" do
      subject.send(method).each do |element|
        element.should respond_to(:each)
      end
    end

    it "returns an array of objects that respond to :name" do
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

  it 'has a type method that returns the correct value' do
    subject.type.should == type
  end

end


%w[title ingredients steps yields prep_time cook_time
   total_time images notes body].each do |method|
  shared_examples_for "#{method}" do |property|
    it "returns the correct #{method}" do
      subject.send(method).should == property
    end
  end
end