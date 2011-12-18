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
        ingredient_sections.map do |section|
          NamedList.new(extract_ingredients_from(section)).tap do |list|
            name = section.at('h4')
            list.name = name.text.chomp(':') if name
          end
        end
      end

      def steps
        steps_sections.map do |section|
          NamedList.new(extract_steps_from(section))
        end
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

      def extract_ingredients_from(section)
        section.search('p').map do |p|
          clean_item(p.text.collapse_whitespace)
        end
      end

      def extract_steps_from(section)
        section.search('li p').map do |p|
          clean_item(p.text.collapse_whitespace)
        end
      end

      def ingredient_sections
        recipe.search('.recipe_ingredients')
      end

      def steps_sections
        # Sometimes there are empty ingredient lists, so
        recipe.search('.recipe_steps').select do |section|
          section.search('li p').any?
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