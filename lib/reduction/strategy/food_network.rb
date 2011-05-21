module Reduction
  class Strategy

    class FoodNetwork < Strategy

      def self.for_url?(url)
        url =~ /www\.foodnetwork\.com/
      end

      def title
        doc.at('.rcp-head h1.fn').text
      end

      def ingredients
        NamedList.from_node_set(ingredient_elements, :h3).each(&:clean!)
      end

      def steps
        [ recipe('.body-text .instructions').text.stripped_lines ]
      end

      def yields
        recipe('#recipe-meta dt.yield').parent.search('dd').text.collapse_whitespace
      end

      def prep_time
        recipe('#recipe-meta dd.prepTime').text.collapse_whitespace
      end

      def cook_time
        recipe('#recipe-meta dd.cookTime').text.collapse_whitespace
      end

      private

      def ingredient_elements
        recipe('.body-text').children
      end

      def recipe(further)
        doc.at('.hrecipe').at(further)
      end

    end

  end
end