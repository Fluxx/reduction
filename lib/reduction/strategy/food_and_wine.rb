require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class FoodAndWine < Strategy

      attr_reader :prep_time, :cook_time

      def self.for_url?(url)
        url =~ /www\.foodandwine\.com/
      end

      def title
        text_at('.recipe-info h1[itemprop=name]').collapse_whitespace
      end

      def ingredients
        [ NamedList.new(doc.at('#ingredients').search('li').map(&:text).
                        map(&:collapse_whitespace)) ]
      end

      def steps
        [ NamedList.new(doc.search(steps_selector).map(&:text).
                        map(&:collapse_whitespace)) ]
      end

      def yields
        text_at('#time-servings strong').collapse_whitespace + ' servings'
      end

      def cook_time
        total_time
      end

      def total_time
        text_at('#time-total strong').collapse_whitespace.downcase
      end

      def notes
      end

      def images
        absolute_img_srcs_from(doc.search('img#featured_image'))
      end

      private

      def steps_selector
        '#directions ol[itemprop=recipeInstructions] li'
      end

    end

  end
end