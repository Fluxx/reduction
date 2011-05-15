module Reduction
  module ArrayExtensions

    def clean!
      collect!(&:collapse_whitespace).reject!(&:empty?)
    end

  end

  Array.send(:include, ArrayExtensions)

end