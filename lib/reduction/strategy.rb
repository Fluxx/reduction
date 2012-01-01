require "nokogiri"

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

    %w[
      title
      ingredients
      steps
      yields
      prep_time
      cook_time
      total_time
      for_url?
    ].each do |method|
      define_method method do
        raise RuntimeError, "#{method} not implemented"
      end
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