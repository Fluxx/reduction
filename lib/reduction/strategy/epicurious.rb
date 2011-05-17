module Reduction
  class Strategy

    class Epicurious < Strategy

      def self.for_url?(url)
        url =~ /www\.epicurious\.com/
      end

      def title
        doc.at('#primary_content h1.fn').text
      end

      def ingredients
        if ingredient_elements.search('strong').any?
          NamedList.from_node_set(ingredient_elements, :strong)
        else
          recipe('ul.ingredientsList').text.stripped_lines
        end
      end

      def steps
        recipe('#preparation').search('p[class!=chefNotes]').text.stripped_lines.map do |l|
          # Epicurious somtimes puts numbers in front of their steps.  This strips them
          # out
          #
          # TODO: Move this to a method
          l.gsub(/^\d\. /, '')
        end
      end

      def yields
        recipe('.summary_data .yield').text.collapse_whitespace
      end

      private

      def recipe(further)
        doc.at('#recipe_detail_module').at(further)
      end

      def prep_time
      end

      def cook_time
      end

      private

      def ingredient_elements
        doc.at('#ingredients').children
      end

    end

  end
end