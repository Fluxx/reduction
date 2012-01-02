require "nokogiri"

module Reduction
  class Strategy

    attr_reader :doc, :url

    INTERFACE_METHODS = %w[ingredients steps prep_time cook_time 
                           total_time yields]

    def initialize(html_doc, url)
      @doc = Nokogiri::HTML(html_doc.to_s)
      @url = url
    end

    def self.all
      subclasses.sort_by(&:priority)
    end

    def self.for_url(url)
      all.find { |s| s.for_url?(url) }
    end

    def self.subclasses
      constants.map { |c| const_get(c) }.select do |possible_class|
        possible_class.is_a?(Class) && possible_class < self
      end
    end

    def self.priority
      1
    end
    
    INTERFACE_METHODS.each do |method|
      define_method method do
        raise RuntimeError, "#{method} not implemented"
      end
    end

    def body
      INTERFACE_METHODS.map do |method|
        key = method.split('_').map(&:capitalize).join(' ')
        "#{key}: #{self.send(method)}"
      end.join("\n")
    end

    def source_url
      @url
    end

    def type
      :blessed
    end

    private

    def absolute_img_srcs_from(images)
      host_uri = URI.parse(url)

      images.map do |img|
        host_uri.merge(URI.parse(img['src'])).to_s
      end
    end

  end
end