module Reduction
  module StringExtensions

    def stripped_lines
      lines.collect(&:strip).reject(&:empty?)
    end

    def collapse_whitespace
      strip.gsub(/\s+/, ' ')
    end

  end

  String.send(:include, StringExtensions)

end