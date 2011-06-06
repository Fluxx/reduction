module Reduction
  class Strategy

    class Food < Strategy

      def self.for_url?(url)
        url =~ /food\.com/
      end

      def title
        doc.at('.recipe-info-page span.item h2.fn').text.collapse_whitespace
      end

      def ingredients
        NamedList.from_node_set(ingredient_elements, :h3)
      end

      def steps
        [ doc.search('.directions ol li span').map(&:text) ]
      end

      def yields
        raw = doc.at('.ingredients input#original_value')[:value]
        raw.collapse_whitespace + ' servings'
      end

      def prep_time
        doc.at('.directions span.prepTime').text
      end

      def cook_time
      end

      def total_time
        doc.at('.directions span.duration').text
      end
      
      private
      
      def ingredient_elements
        @ingredient_elements ||= doc.at('.ingredients').children
      end

    end

  end
end