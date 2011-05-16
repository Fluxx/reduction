module Reduction
  class Strategy

    class Chow < Strategy

      def self.for_url?(url)
        url =~ /chow\.com/
      end

      def title
        doc.at('#title h1').text
      end

      def ingredients
        if ingredient_elements.search('h4').any?
          multi_part_ingredients_section
        else
          single_ingredients_section
        end
      end

      def steps
        if steps_elements.search('strong').any?
          multi_part_steps_section
        else
          single_steps_section
        end
      end

      def yields
        doc.at('#servings span[itemprop=yield]').text
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
        doc.at('#servings p[2] time[itemprop=totalTime]').text.collapse_whitespace
      end

      private

      def ingredient_elements
        @ingredient_elements ||= doc.at('#ingredients').children
      end

      def multi_part_ingredients_section
        stack = Array.new

        ingredient_elements.each do |elem|
          case elem.name.to_sym
          when :h4
            stack.push(NamedList.new.tap { |l| l.name = elem.text })
          when :ul
            list = stack.pop
            ingredient_list = elem.search('li').map(&:text)
            ingredient_list.clean!
            stack.push(list.replace(ingredient_list))
          end
        end

        stack
      end

      def single_ingredients_section
        ingredient_elements.search('li').map(&:text).map(&:collapse_whitespace)
      end

      def steps_elements
        @steps_elements ||= doc.at('#instructions').children
      end

      def multi_part_steps_section
        stack = Array.new

        steps_elements.each do |elem|
          case elem.name.to_sym
          when :strong
            stack.push(NamedList.new.tap { |l| l.name = elem.text })
          when :ol
            list = stack.pop
            ingredient_list = elem.search('li').map(&:text)
            ingredient_list.clean!
            stack.push(list.replace(ingredient_list))
          end
        end

        stack
      end

      def single_steps_section
        steps_elements.search('li').collect(&:text)
      end

    end

  end
end