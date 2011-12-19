module Reduction
  module ArrayExtensions

    def clean!
      collect!(&:collapse_whitespace).reject!(&:empty?)
    end

  end

  puts "Adding ArrayExtensions to Array"
  Array.send(:include, ArrayExtensions)

end