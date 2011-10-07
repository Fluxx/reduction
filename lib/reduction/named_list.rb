require "delegate"
require "multi_json"

module Reduction

  class NamedList < DelegateClass(Array)
    attr_accessor :name

    def initialize(*args)
      super(Array.new(*args))
    end

    def to_json(*a)
      {
        :json_class => self.class.name,
        :data => { :name => @name, :list => self.to_a}
      }.to_json(*a)
    end

    def self.json_create(object)
      new(object['data']['list']).tap do |list|
        list.name = object['data']['name']
      end
    end

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