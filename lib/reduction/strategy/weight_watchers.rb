require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class WeightWatchers < Strategy

      def self.for_url?(url)
        url =~ /www\.weightwatchers\.com/
      end

      def title
        doc.at('.article-intro h1').text.collapse_whitespace
      end

      def ingredients
        [NamedList.new(raw_ingredients)]
      end

      def steps
        [NamedList.new(raw_steps)]
      end

      def yields
        doc.at('.rec-sum2-2').text.collapse_whitespace.gsub(':', '')
      end

      def prep_time
        de_span('.prep-time')
      end

      def cook_time
        de_span('.cook-time')
      end

      def total_time
      end

      def images
        absolute_img_srcs_from(doc.search('.article-img img'))
      end

      def notes
        if notes_elements = recipe.xpath('ul[2]/li')
          notes_elements.text if notes_elements.any?
        end
      end

      private

      def recipe
        doc.at('.recipe_int')
      end

      def raw_ingredients
        recipe.search('table.ww-r-info td').text.stripped_lines.reject do |line|
          line.gsub(/^\W+/, '').empty?
        end
      end

      def raw_steps
        recipe.xpath('ul[1]/li').map(&:text).map(&:strip)
      end

      def de_span(selector)
        texts = doc.at(selector).children.select(&:text?)
        texts.join.collapse_whitespace.gsub(/^\W+/, '')
      end

    end

  end
end