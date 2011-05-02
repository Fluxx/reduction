module Reduction
  class Strategy

    class AllRecipes < Strategy

      def self.for_url?(url)
        url =~ /allrecipes\.com/
      end

      def title
        doc.at('title').text.split('-').first.strip
      end

      def ingredients
        recipe('.ingredients ul').text.stripped_lines
      end

      def steps
        recipe('.directions ol').text.stripped_lines
      end

      def yields
        recipe('.yield').text
      end

      def prep_time
        recipe('h5[1] span[3]').text
      end

      def cook_time
        recipe('h5[2] span[3]').text
      end

      private

      def recipe(further)
        doc.at('.recipe-details-content').at(further)
      end

    end

  end
end