module Reduction
  class Strategy

    attr_reader :doc, :url

    def initialize(html_doc, url)
      @doc = Nokogiri::HTML(html_doc.to_s)
      @url = url
    end

    def self.all
      subclasses
    end

    def self.for_url(url)
      all.find { |s| s.for_url?(url) }
    end

    def self.subclasses
      constants.map { |c| const_get(c) }.select { |klass| klass < self }
    end

    %w[title ingredients steps yields prep_time cook_time for_url?].each do |method|
      define_method method do
        raise RuntimeError, "#{method} not implemented"
      end
    end

    def total_time
      "Prep Time: #{prep_time}. Cook Time: #{cook_time}"
    end

  end
end