require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

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
        NamedList.from_node_set(ingredient_elements, :h4)
      end

      def steps
        NamedList.from_node_set(steps_elements, :strong)
      end

      def yields
        doc.at('span[itemprop=yield]').text
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
        doc.at('time[itemprop=totalTime]').text.collapse_whitespace
      end

      def images
        absolute_img_srcs_from(relevent_images)
      end

      private

      def relevent_images
        doc.search('.content img').reject do |img|
          img['src'] =~ Regexp.new("clear.gif|difficulty_[a-z]+.jpg")
        end
      end

      def ingredient_elements
        @ingredient_elements ||= doc.at('#ingredients').children
      end

      def steps_elements
        @steps_elements ||= doc.at('#instructions').children
      end

    end

  end
end