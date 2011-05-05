module Reduction
  class Strategy

    class Food < Strategy

      def self.for_url?(url)
        url =~ /food\.com/
      end

      def title
        doc.at('.recipe-info-page span.item h2.fn').text.gsub(/\W+/, ' ').strip
      end

      def ingredients
        doc.at('.ingredients ul.clr').search('li').collect(&:text).collect do |item|
          item.gsub(/\W+/, ' ').strip
        end
      end

      def steps
        doc.search('.directions ol li span').map(&:text)
      end

      def yields
        raw = doc.at('.ingredients input#original_value')[:value]
        raw.gsub(/\W+/, ' ').strip + ' servings'
      end

      def prep_time
        doc.at('.directions span.prepTime').text
      end

      def cook_time
      end

      def total_time
        doc.at('.directions span.duration').text
      end

    end

  end
end