module Reduction
  class Strategy

    class Chow < Strategy

      def self.for_url?(url)
        url =~ /chow\.com/
      end

      def title
        doc.at('#title h1').text
      end

      def ingredients
        doc.at('#ingredients ul').text.stripped_lines
      end

      def steps
        doc.at('#instructions ol').search('li').collect(&:text)
      end

      def yields
        doc.at('#servings span[itemprop=yield]').text
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
        doc.at('#servings p[2] time[itemprop=totalTime]').text.collapse_whitespace
      end

    end

  end
end