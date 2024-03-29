require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class Chow < Strategy

      EXTRA_INFO = /beverage pairing/i

      def self.for_url?(url)
        url =~ /chow\.com/
      end

      def title
        text_at('#title h1')
      end

      def ingredients
        NamedList.from_node_set(ingredient_elements, :h4)
      end

      def steps
        NamedList.from_node_set(steps_elements, :strong, :p)
      end

      def yields
        text_at('span[itemprop=yield]')
      end

      def prep_time
      end

      def cook_time
        total_time || active_time
      end

      def total_time
        if tt = doc.at('time[itemprop=totalTime]')
          tt.text.collapse_whitespace
        end
      end

      def active_time
        if at = doc.at('time[itemprop=activeTime]')
          at.text.collapse_whitespace
        end
      end

      def images
        absolute_img_srcs_from(relevent_images)
      end

      def notes
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
        @steps_elements ||= doc.at('#instructions').children.select do |e|
          !e.text.match(EXTRA_INFO)
        end
      end

    end

  end
end