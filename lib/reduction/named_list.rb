module Reduction

  class NamedList < Array
    attr_accessor :name

    def self.from_node_set(nodeset, title_elem)
      stack = Array.new

      nodeset.each do |elem|
        case elem.name.to_sym
        when title_elem.to_sym
          stack.push(new.tap { |l| l.name = elem.text.collapse_whitespace })
        when :ul, :ol
          if (stack.last).is_a?(self) && stack.last.empty?
            ingredient_list = elem.search('li').map(&:text)
            ingredient_list.clean!
            stack.last.replace(ingredient_list)
          else
            list = new(elem.search('li').map(&:text))
            list.clean!
            stack.push(list)
          end
        end
      end

      stack
    end

  end

end