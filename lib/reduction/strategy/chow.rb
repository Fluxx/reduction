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
        if ingredient_elements.search('h4').any?
          NamedList.from_node_set(ingredient_elements, :h4)
        else
          ingredient_elements.search('li').map(&:text).map(&:collapse_whitespace)
        end
      end

      def steps
        if steps_elements.search('strong').any?
          NamedList.from_node_set(steps_elements, :strong)
        else
          steps_elements.search('li').collect(&:text)
        end
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

      private

      def ingredient_elements
        @ingredient_elements ||= doc.at('#ingredients').children
      end

      def steps_elements
        @steps_elements ||= doc.at('#instructions').children
      end

    end

  end
end