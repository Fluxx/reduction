module Reduction

  class NamedList < Array
    attr_accessor :name

    def self.from_node_set(nodeset, title_elem)
      stack = Array.new

      nodeset.each do |elem|
        case elem.name.to_sym
        when title_elem.to_sym
          stack.push(NamedList.new.tap { |l| l.name = elem.text })
        when :ul, :ol
          if list = stack.pop
            ingredient_list = elem.search('li').map(&:text)
            ingredient_list.clean!
            stack.push(list.replace(ingredient_list))
          end
        end
      end

      stack
    end
  end

end