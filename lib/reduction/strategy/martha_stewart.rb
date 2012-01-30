require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class MarthaStewart < Strategy

      def self.for_url?(url)
        url =~ /www\.marthastewart\.com/
      end

      def title
        text_at('.title-section h1')
      end

      def ingredients
        [NamedList.new(raw_ingredients)]
      end

      def steps
        [NamedList.new(raw_steps)]
      end

      def yields
        text_at('.recipe-info li.yield').gsub(/Yield/, '').strip
      end

      def prep_time
        text_at('.recipe-info .preptime').strip
      rescue
        nil
      end

      def cook_time
      end

      def total_time
        text_at('.recipe-info .duration')
      rescue
        nil
      end

      def images
        absolute_img_srcs_from(doc.search('.images li img'))
      end

      def notes
        if notes_elem = doc.at('.cooks-note')
          notes_elem.search('p').map(&:text).clean!.join("\n\n")
        end
      end

      private

      def raw_ingredients
        doc.search('.ingredients li').map(&:text).map(&:collapse_whitespace)
      end

      def raw_steps
        doc.search('.instructions li').map(&:text).map(&:collapse_whitespace)
      end

    end

  end
end