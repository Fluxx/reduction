# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Food do

      use_vcr_cassette 'food'

      context 'a normal recipe' do

        strategy_subject_for('http://www.food.com/recipe/yummy-frozen-margaritas-292214')

        it_should_behave_like "a strategy", :blessed

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

        it_should_find 'images', [
          "http://food.sndimg.com/img/recipes/29/22/14/large/picDrdxNy.jpg"
        ]

      end

      context 'a recipe with multiple ingredient lists' do
        strategy_subject_for('http://www.food.com/recipe/best-ever-banana-cake-with-cream-cheese-frosting-67256')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'ingredients', [
          [
            "1 1/2 cups bananas , mashed, ripe",
            "2 teaspoons lemon juice",
            "3 cups flour",
            "1 1/2 teaspoons baking soda",
            "1/4 teaspoon salt",
            "3/4 cup butter , softened",
            "2 1/8 cups sugar",
            "3 large eggs",
            "2 teaspoons vanilla",
            "1 1/2 cups buttermilk"
          ],
          [
            "1/2 cup butter , softened",
            "1 (8 ounce) package cream cheese , softened",
            "1 teaspoon vanilla",
            "3 1/2 cups icing sugar"
          ],
          [
            "chopped walnuts"
          ]
        ]

        it 'matches the ingredient list names correctly' do
          subject.ingredients.map(&:name).should == [nil, 'Frosting', 'Garnish']
        end

        it_should_find 'images', [
          "http://food.sndimg.com/img/recipes/67/25/6/large/pichIPBA2.jpg"
        ]

      end

    end

  end

end