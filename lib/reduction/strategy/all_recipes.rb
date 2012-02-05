require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class AllRecipes < Strategy

      def self.for_url?(url)
        url =~ /allrecipes\.com/
      end

      reduce :title do
        text_at('title').split('-').first.collapse_whitespace
      end

      reduce :ingredients do
        ingredient_lists.map do |array|
          NamedList.new(array).tap do |nl|
            nl.name = nl.shift.chomp(':') if nl.first =~ /:$/
          end
        end
      end

      reduce :steps do
        [ NamedList.new(recipe('.directions ol').text.stripped_lines) ]
      end

      reduce :yields do
        recipe('.yield').text
      end

      reduce :prep_time do
        recipe('h5[1] span[3]').text
      end

      reduce :cook_time do
        recipe('h5[2] span[3]').text
      end

      reduce :total_time do
        recipe('h5[3] span[3]').text.collapse_whitespace
      end

      reduce :notes do
      end

      reduce :images do
        absolute_img_srcs_from(doc.search('#recipemasthead img.rec-image.photo'))
      end

      private

      def ingredient_lists
        chunked_ingredient_lists.select { |empty, l| !empty }.map(&:last)
      end

      def chunked_ingredient_lists
        recipe('.ingredients ul li').map(&:text).map(&:strip).chunk do |item|
          !!(item.empty? || item =~ /^\W+$/)
        end
      end

      def recipe(further)
        doc.at('.recipe-details-content').search(further)
      end

    end

  end
end