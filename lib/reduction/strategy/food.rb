require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class Food < Strategy

      def self.for_url?(url)
        url =~ /food\.com/
      end

      def title
        text_at('#rz-lead h1.fn').collapse_whitespace
      end

      def ingredients
        NamedList.from_node_set(ingredient_elements, :h3)
      end

      def steps
        [ NamedList.new(doc.search('.directions ol li div.txt').map(&:text)) ]
      end

      def yields
        raw = doc.at('.ingredients input#original_value')[:value]
        raw.collapse_whitespace + ' servings'
      end

      def prep_time
        res = doc.at('.recipe-item').search('p.preptime', 'p.prepTime')
        res.first.text if res.any?
      end

      def cook_time
        # TODO: Add this, it's on the page now
      end

      def total_time
        doc.at('.recipe-item h3.duration').text
      end

      def images
        absolute_img_srcs_from(doc.search('.recipe-item .smallPageImage'))
      end

      def notes
      end
      
      private
      
      def ingredient_elements
        @ingredient_elements ||= doc.at('.ingredients').children
      end

    end

  end
end