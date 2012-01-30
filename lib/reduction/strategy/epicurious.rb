require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class Epicurious < Strategy

      def self.for_url?(url)
        url =~ /www\.epicurious\.com/
      end

      def title
        text_at('#primary_content h1.fn')
      end

      def ingredients
        NamedList.from_node_set(ingredient_elements, :strong)
      end

      def steps
        if steps_elements.search('strong').any?
          multiple_steps_lists
        else
          steps = steps_elements.search('p[class!=chefNotes]').search('p.instruction').
            collect(&:text)
          steps.clean!
          # Epicurious somtimes puts numbers in front of their steps.  This strips them
          # out
          #
          # TODO: Move this to a method
          [ NamedList.new(steps.map { |l| l.gsub(/^\d\. /, '') }) ]
        end
      end

      def yields
        recipe('.summary_data .yield').text.collapse_whitespace
      rescue
        ''
      end

      def recipe(further)
        doc.at('#recipe_detail_module').at(further)
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
      end

      def notes
      end

      def images
        absolute_img_srcs_from(normalized_images)
      end

      private

      def normalized_images
        doc.search('#recipe_thumb img').map do |img|
          img.set_attribute('src', img['src'].gsub(/\n|\r/, ''))
          img
        end
      end

      def multiple_steps_lists
        stack = Array.new

        steps_elements.search('p').each do |element|
          if element.search('strong').any?
            title = element.at('strong').remove
            list = NamedList.new
            list << element.text.collapse_whitespace
            list.name = title.text.collapse_whitespace
            stack.push(list)
          else
            if stack.last.is_a?(NamedList)
              stack.last << element.text.collapse_whitespace
            end
          end
        end

        stack
      end

      def ingredient_elements
        doc.at('#ingredients').children.search('strong', 'ul')
      end

      def steps_elements
        recipe('#preparation').children
      end

    end

  end
end