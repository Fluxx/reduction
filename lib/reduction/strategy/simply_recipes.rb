require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class SimplyRecipes < Strategy

      def self.for_url?(url)
        url =~ /simplyrecipes\.com/
      end

      def title
        recipe.at('h2').text
      end

      def ingredients
        [main_ingredient_list].tap do |arr|
          arr << additional_ingredient_list if additional_ingredient_list.any?
        end
      end

      def steps
        [NamedList.new(cleaned_steps)]
      end

      def yields
        (yields_element_text || last_step_yields || "").chomp('.')
      end

      def prep_time
        if element = doc.at('#recipe-meta .recipe-prep .preptime')
          element.text
        end
      end

      def cook_time
        if element = doc.at('#recipe-meta .recipe-cook .cooktime')
          element.text
        end
      end

      def total_time
      end

      def images
        absolute_img_srcs_from(raw_images)
      end

      def notes
        if element = recipe.at('#recipe-intronote')
          element.text.collapse_whitespace.strip
        end
      end

      private

      def yields_element_text
        if element = recipe.at('span.yield')
          element.text
        end
      end

      def last_step_yields
        raw_steps.find { |s| s =~ /^Serves/ }
      end

      def cleaned_steps
         raw_steps.reject do |step|
          step.empty? || step =~ /^Yield|Serves/ 
        end
      end

      def raw_steps
        recipe.search('#recipe-method p').map(&:text)
      end

      def main_ingredient_list
        NamedList.new(ingredient_list.map(&:text))
      end

      def additional_ingredient_list
        NamedList.new(ingredient_list(2).map(&:text)).tap do |list|
          possible_name = recipe.search('p em').first
          list.name = possible_name.text.chomp(':') if possible_name
        end

      end

      def ingredient_list(num = 1)
        recipe.at('#recipe-ingredients').xpath("ul[#{num}]/li")
      end

      def raw_images
        recipe.search('img').reject do |img|
          img['src'] =~ /icon-print/
        end
      end

      def recipe
        doc.at('#recipe-callout')
      end

    end

  end
end