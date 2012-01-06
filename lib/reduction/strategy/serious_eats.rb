require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class SeriousEats < Strategy

      def self.for_url?(url)
        url =~ /www\.seriouseats\.com/
      end

      def title
        doc.at('.indPost-recipe-title h2').text
      end

      def ingredients
        [NamedList.new(doc.search('.ingredients-section ul li').map(&:text))]
      end

      def steps
        texts = doc.search('.procedure-steps li .procedure-text').map(&:text)
        [ NamedList.new(texts.map(&:collapse_whitespace)) ]
      end

      def yields
        doc.at('.ingredients-header .yield').text
      end

      def prep_time
        doc.at('.ingredients-header .preptime').text
      end

      def cook_time
        doc.at('.ingredients-header .duration').text
      end

      def total_time
      end

      def images
        absolute_img_srcs_from(doc.search('.recipe-image-large img'))
      end

      def notes
        if entry = doc.at('#entry-text')
          paragraph_text = entry.xpath('p[2]').text
          paragraph_text.gsub(/^Note: /, '') if paragraph_text =~ /^Note: /
        end
      end

      private

    end

  end
end