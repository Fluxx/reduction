require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class MyRecipes < Strategy

      def self.for_url?(url)
        url =~ /www\.myrecipes\.com/
      end

      def title
        text_at('h1.x4-headline')
      end

      def ingredients
        ingredient_lists
      end

      def steps
        [NamedList.new(raw_steps)]
      end

      def yields
        text_at('.recipe411 span[itemprop=yield]')
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
        if time = doc.at('.recipe411 time[itemprop=total]')
          time.text.collapse_whitespace
        end
      end

      def images
        absolute_img_srcs_from(doc.search('.photo img[itemprop=photo]'))
      end

      def notes
        if notes_elem = doc.at('.cooks-note')
          notes_elem.search('p').map(&:text).clean!.join("\n\n")
        end
      end

      private

      def ingredient_lists
        Array.new.tap do |lists|
          chunked_ingredients.each do |is_title, elements|
            if is_title
              list = NamedList.new
              list.name = elements.first.text.capitalize
              lists << list
            else
              lists << NamedList.new unless lists.last
              lists.last.replace(ingredient_elements_to_text(elements))
            end
          end
        end
      end

      def ingredient_elements_to_text(elements)
        elements.map(&:text).map(&:collapse_whitespace).map do |text|
          text.gsub('*', '')
        end
      end

      def chunked_ingredients
        doc.search('.recipeDetails > ul > li').chunk do |li|
          li['itemprop'] != 'ingredient'
        end
      end

      def raw_steps
        doc.search('ol[itemprop=instructions] li').map do |element|
          element.text.gsub(/^\d\.\W+/, '')
        end
      end

    end

  end
end