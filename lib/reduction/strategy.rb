module Reduction
  class Strategy

    attr_reader :doc

    def initialize(html_doc)
      @doc = Nokogiri::HTML(html_doc.to_s)
    end

    %w[title ingredients steps yields prep_time cook_time for_url?].each do |method|
      define_method method do
        raise RuntimeError, "#{method} not implemented"
      end
    end

    def total_time
      "Prep Time: #{prep_time}. Cook Time: #{cook_time}"
    end

    def self.subclasses
      constants.map { |c| const_get(c) }.select { |klass| klass < self }
    end

  end
end