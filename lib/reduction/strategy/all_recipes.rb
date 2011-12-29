require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class AllRecipes < Strategy

      def self.for_url?(url)
        url =~ /allrecipes\.com/
      end

      def title
        doc.at('title').text.split('-').first.collapse_whitespace
      end

      def ingredients
        zipped_ingredients.map do |list, title|
          NamedList.new(list).tap do |l|
            l.name = title if title
          end
        end
      end

      def steps
        [ NamedList.new(recipe('.directions ol').text.stripped_lines) ]
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

      def notes
      end

      def images
        absolute_img_srcs_from(doc.search('#recipemasthead img.rec-image.photo'))
      end

      private

      def zipped_ingredients
        ingredient_lists.zip(ingredient_titles)
      end

      def ingredient_titles
        ingredients_is_title(true).flatten.map do |title|
          title.chomp(':')
        end
      end

      def ingredient_lists
        ingredients_is_title(false)
      end

      def ingredients_is_title(is_list)
        chunked_ingredients.select { |i| i.first == is_list }.map(&:last)
      end

      def chunked_ingredients
        raw_ingredient_lines.chunk { |line| !! line.match(/:$/) }
      end

      def raw_ingredient_lines
        recipe('.ingredients ul').text.stripped_lines.select do |i|
          !i.chop.empty?
        end
      end

      def recipe(further)
        doc.at('.recipe-details-content').at(further)
      end

    end

  end
end