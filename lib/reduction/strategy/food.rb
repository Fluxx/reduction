module Reduction
  class Strategy

    class Food < Strategy

      def self.for_url?(url)
        url =~ /food\.com/
      end

      def title
        doc.at('#rz-lead h1.fn').text.collapse_whitespace
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
        doc.at('.recipe-item p.preptime').text
      end

      def cook_time
        # TODO: Add this, it's on the page now
      end

      def total_time
        doc.at('.recipe-item h3.duration').text
      end

      def images
        absolute_img_srcs_from(doc.search('.recipe-item .largePageImage'))
      end
      
      private
      
      def ingredient_elements
        @ingredient_elements ||= doc.at('.ingredients').children
      end

    end

  end
end