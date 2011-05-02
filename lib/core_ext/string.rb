module Reduction
  module StringExtensions

    def stripped_lines
      lines.collect(&:strip).reject(&:empty?)
    end

  end

  String.send(:include, StringExtensions)

end