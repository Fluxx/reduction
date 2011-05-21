# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Food do

      use_vcr_cassette 'food'

      context 'a normal recipe' do
        
        subject { described_class.new(get_page('http://www.food.com/recipe/yummy-frozen-margaritas-292214')) }

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any chow.com URL' do
            described_class.for_url?('http://food.com').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.chowfoods.com').should be_false
          end

        end

        it_should_find 'title', 'Yummy Frozen Margaritas'

        it 'does not include chow in the title' do
          subject.title.should_not =~ /food.com/i
        end

        it_should_find 'ingredients', [
          [
            "6 ounces frozen limeade concentrate",
            "6 ounces tequila",
            "2 ounces triple sec"
          ]
        ]

        it_should_find 'steps', [
          [
            "Fill blender with crushed ice.",
            "Add three ingredients and blend till thick."
          ]
        ]

        it_should_find 'yields', '4 servings'

        it_should_find 'prep_time', '5 mins'

        it_should_find 'cook_time', nil

        it_should_find 'total_time', '5 mins'
        
      end
      
      context 'a recipe with multiple ingredient lists' do
        subject { described_class.new(get_page('http://www.food.com/recipe/best-ever-banana-cake-with-cream-cheese-frosting-67256')) }
        it_should_behave_like "a strategy"
        # TODO: specific checks
      end
        
      context 'a recipe with multiple step lists' do
        subject { described_class.new(get_page('http://www.food.com/recipe/best-ever-banana-cake-with-cream-cheese-frosting-67256')) }
        it_should_behave_like "a strategy"
        # TODO: specific checks
      end

    end

  end

end