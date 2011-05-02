module Reduction
  class Strategy

    class FoodNetwork < Strategy

      def title
        doc.at('.rcp-head h1.fn').text
      end

      def ingredients
        recipe('.body-text ul').text.stripped_lines
      end

      def steps
        recipe('.body-text .instructions').text.stripped_lines
      end

      def yields
        recipe('.rcp-info li[3] p').text
      end

      def prep_time
        recipe('.preptime').text
      end

      def cook_time
        recipe('.rcp-info li[1] p').text
      end

      private

      def recipe(further)
        doc.at('.fn-we').at(further)
      end

    end

  end
end