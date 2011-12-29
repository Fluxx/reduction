require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class Saveur < Strategy

      def self.for_url?(url)
        url =~ /www\.saveur\.com/
      end

      def title
        doc.at('h1.title').text.collapse_whitespace
      end

      def ingredients
        [ NamedList.new(body_list('INGREDIENTS', 'h4')) ]
      end

      def steps
        [ NamedList.new(cleaned_steps) ]
      end

      def yields
        doc.at('div.body').inner_html.match(/MAKES[^<]*/)[0].capitalize
      end

      def prep_time
      end

      def cook_time
      end

      def total_time
      end

      def images
        doc.search('div.image img.medium').map { |i| i['src'] }
      end

      def notes
      end

      private

      def cleaned_steps
        body_list('INSTRUCTIONS', 'a').reject(&:empty?).map do |step|
          step.gsub(/\d\.\W+/, '')
        end
      end

      def body_list(start, ending)
        recipe_body.match("<h4>#{start}</h4>(.*)<#{ending}")[1].split('<br>')
      end

      def recipe_body
        doc.at('div.body').inner_html
      end

    end

  end
end