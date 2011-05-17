module Reduction
  class Strategy

    class FoodAndWine < Strategy

      attr_reader :prep_time, :cook_time

      def self.for_url?(url)
        url =~ /www\.foodandwine\.com/
      end

      def title
        doc.at('.recipe-info h2[itemprop=name]').text.collapse_whitespace
      end

      def ingredients
        doc.at('#ingredients').search('li').map(&:text).map(&:collapse_whitespace)
      end

      def steps
        doc.search('#directions ol[itemprop=instructions] li').map(&:text).
          map(&:collapse_whitespace)
      end

      def yields
        doc.at('#time-servings strong').text.collapse_whitespace + ' servings'
      end

      def total_time
        doc.at('#time-total strong').text.collapse_whitespace.downcase
      end

    end

  end
end