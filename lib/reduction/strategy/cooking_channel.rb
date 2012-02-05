require 'reduction/strategy'
require 'reduction/named_list'
require 'reduction/core_ext/string'

module Reduction
  class Strategy

    class CookingChannel < Strategy

      NON_STEP_TEXTS = [
        'Cook\'s Note: ',
        'Nutritional information',
        'You save',
        'Make it a Drop',
        'Excellent source of',
        'Good source of'
      ]

      NON_STEPS = Regexp.new(NON_STEP_TEXTS.join('|'))

      def self.for_url?(url)
        url =~ /www.cookingchanneltv.com\/recipes/
      end

      reduce :title do
        text_at('.hrecipe h1')
      end

      reduce :ingredients do
        named_list = NamedList.new(ingredient_elements.map(&:text))
        [named_list]
      end

      reduce :steps do
        [NamedList.new(raw_steps.reject { |l| l =~ NON_STEPS })]
      end

      reduce :yields do
        text_at('.rspec_ccyield .value')
      end

      reduce :prep_time do
        text_at('.prepTime .value-title')
      end

      reduce :cook_time do
        text_at('.rspec-cook-time .value-title')
      end

      reduce :total_time do
        text_at('.totaltime .value-title')
      end

      reduce :images do
        [ doc.at('#rec-photo a')['href'] ]
      end

      reduce :notes do
        raw_steps.find { |l| l =~ NON_STEPS }.gsub(NON_STEPS, '')
      end

      private

      def raw_steps
        doc.search('.steps .instructions').inner_html.split('<br>').clean!
      end

      def ingredient_elements
        doc.search('.ingredients li')
      end

    end

  end
end