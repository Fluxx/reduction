require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

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
        multiple_steps_elements.tap do |lists|
          # FoodNetwork uses the same level of heading to describe the entire
          # steps section ("Directions") as they use to label idividual sections.
          # Since "Directions" is not a very good name of a list, and it is
          # misleading - since it's not ALL of the directions, we remove it.
          lists.first.name = nil if lists.first.name =~ /directions/i
        end
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

      def total_time
      end

      def notes
      end

      def images
        absolute_img_srcs_from(doc.search('#recipe-lead img.photo'))
      end

      private

      def multiple_steps_elements
        stack = Array.new

        steps_elements.each do |element|
          case element.name.to_sym
          when :h2
            list = NamedList.new
            list.name = element.text.collapse_whitespace
            stack.push(list)
          when :div
            if element['class'] == 'instructions'
              new_items = element.search('p').map(&:text).map(&:collapse_whitespace)
              stack.last.concat(new_items.reject(&:empty?))
            end
          end
        end

        stack.reject(&:empty?)
      end

      def steps_elements
        recipe('.body-text').children
      end

      def ingredient_elements
        recipe('.body-text').children
      end

      def recipe(further)
        doc.at('.hrecipe').at(further)
      end

    end

  end
end