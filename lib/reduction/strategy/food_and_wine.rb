module Reduction
  class Strategy

    class FoodAndWine < Strategy

      attr_reader :prep_time, :cook_time

      def self.for_url?(url)
        url =~ /www\.foodandwine\.com/
      end

      def title
        doc.at('.recipe-info h2[itemprop=name]').text.strip
      end

      def ingredients
        doc.at('#ingredients').search('li').map(&:text).map(&:strip)
      end

      def steps
        doc.search('#directions ol[itemprop=instructions] li').map(&:text).map(&:strip)
      end

      def yields
        doc.at('#time-servings strong').text.strip + ' servings'
      end

      def total_time
        doc.at('#time-total strong').text.strip.downcase
      end

    end

  end
end