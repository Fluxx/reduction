module Reduction
  class Strategy

    class Food52 < Strategy

      def self.for_url?(url)
        url =~ /food52\.com/
      end

      def title
        recipe.at('h1.individual').text
      end

      def ingredients
        [ NamedList.new(raw_ingredients) ]
      end

      def steps
        [ NamedList.new(raw_steps) ]
      end

      def yields
        recipe.at('.recipe_info h3.activity_count').text
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
      end

      def images
        absolute_img_srcs_from(recipe.search('.image_container img'))
      end

      private

      def raw_ingredients
        recipe.search('.recipe_ingredients p').map do |p|
          clean_item(p.text.collapse_whitespace)
        end
      end

      def raw_steps
        recipe.search('.recipe_steps li p').map do |p|
          clean_item(p.text.collapse_whitespace)
        end
      end

      # They add a 'Ask the hotline about this ingredient!' text for each
      # ingredient that needs to be removed
      def clean_item(text)
        text.chomp('Ask the hotline about this ingredient!').strip
      end

      def recipe
        doc.at('div.recipe_viewer')
      end

    end

  end
end