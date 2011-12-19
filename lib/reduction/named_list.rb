require 'reduction/core_ext/array'
require "delegate"
require "forwardable"
require "multi_json"
require "yaml"

module Reduction

  class NamedList
    extend Forwardable

    # Basically, forward everything provided by instances of the Array class,
    # as well as the equality methids
    ARRAY_INSTANCE_METHODS = Array.instance_methods - Object.instance_methods

    EQUALITY_METHODS = %w[== > >= < <= <=>]

    # Forwarding to the internal Array is necessary as using a delegator causes
    # an exception on YAML.dump when it subclasses DelegateClass.
    def_delegators :@arr, *(ARRAY_INSTANCE_METHODS + EQUALITY_METHODS)

    attr_accessor :name

    def initialize(*args)
      @arr = Array.new(*args)
    end

    # def ==(obj)
    #   @arr == obj.to_a
    # end

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