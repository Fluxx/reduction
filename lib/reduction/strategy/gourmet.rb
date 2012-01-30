require 'reduction/strategy'
require 'reduction/named_list'

module Reduction
  class Strategy

    class Gourmet < Strategy

      def self.for_url?(url)
        url =~ /www\.gourmet\.com/
      end

      def title
        text_at('title').split(':').first
      end

      def ingredients
        [ NamedList.new(raw_ingredients.collect { |i| i.gsub(/\s+/, ' ').strip}) ]
      end

      def steps
        [ NamedList.new(raw_steps.collect { |i| i.gsub(/\s+/, ' ').strip }) ]
      end

      def yields
        doc.at('.recipe .yield').children.collect(&:text).collect(&:strip).reject do |i|
          i.empty?
        end.join(' ')
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
        # doc.at('#servings p[2]').children[1].text.strip
      end

      def notes
      end

      def images
        absolute_img_srcs_from(doc.search('.recipe img'))
      end

      private

      def raw_ingredients
        doc.at('.ingredient-set ul').search('li').collect(&:text)
      end

      def raw_steps
        doc.at('.preparation').search('li').collect(&:text)
      end

    end

  end
end