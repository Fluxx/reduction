shared_examples_for "a strategy" do

  %w[title ingredients steps yields prep_time cook_time].each do |method|

    it "should not raise an exeption when calling ##{method}" do

      expect {
        subject.send(method)
      }.to_not raise_exception

    end

  end

end


%w[title ingredients steps yields prep_time cook_time].each do |method|
  shared_examples_for "#{method}" do |property|
    it "should return the correct #{method}" do
      subject.send(method).should == property
    end
  end
end