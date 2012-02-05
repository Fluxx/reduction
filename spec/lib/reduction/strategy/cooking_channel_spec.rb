# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe CookingChannel do
      use_vcr_cassette 'cooking_channel'

      context 'normal recipe page' do

        strategy_subject_for('http://www.cookingchanneltv.com/recipes/giada-de-laurentiis/clams-casino-recipe/index.html')

        it_should_behave_like "a strategy", :blessed

        describe 'for_url?' do

          it 'returns true for any chow.com URL' do
            described_class.for_url?('http://www.cookingchanneltv.com/recipes').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.cookingchanneltv.com/').should be_false
            described_class.for_url?('http://www.cctv.com/').should be_false
          end

        end

        it_should_find 'title', 'Clams Casino'

        it_should_find 'ingredients', [
          [
            "2 tablespoons olive oil",
            "2 ounces sliced pancetta or bacon, finely chopped",
            "1 cup finely diced red bell pepper",
            "1/3 cup chopped shallots",
            "2 large garlic cloves, minced",
            "1/4 teaspoon dried oregano",
            "1/3 cup dry white wine",
            "4 tablespoons freshly grated Parmesan",
            "Salt and freshly ground black pepper",
            "18 medium (2 1/2-inch) littleneck clams, shucked, bottom shells reserved"
          ]
        ]

        it_should_find 'steps', [
          [
            "Heat the oil in a heavy large skillet over medium heat. Add the pancetta and saute until crisp and golden, about 3 minutes. Using a slotted spoon, transfer the pancetta to a plate. Add the bell pepper, shallots, garlic, and oregano to the same skillet and saute until the shallots are tender and translucent, about 5 minutes. Add the wine and simmer until it is almost evaporated, about 2 minutes. Remove the skillet from the heat and cool completely. Stir the reserved pancetta and 2 tablespoons of Parmesan cheese into the vegetable mixture. Season the mixture, to taste, with salt and pepper.",
            "Preheat the oven to 500 degrees F.",
            "Line a heavy large baking sheet with foil. Arrange the clams in the reserved shells on the baking sheet. Spoon the vegetable mixture atop the clams, dividing equally and mounding slightly. Sprinkle with the remaining 2 tablespoons of Parmesan. Bake until the clams are just cooked through and the topping is golden, about 10 minutes.",
            "Arrange the clams on the platter and serve."
          ]
        ]

        it_should_find 'prep_time', '20 min'
        it_should_find 'cook_time', '25 min'
        it_should_find 'total_time', '45 min'
        it_should_find 'yields', '6 servings'

        it_should_find 'notes', nil

        it_should_find 'images', ["http://img.foodnetwork.com/FOOD/2009/03/16/EI0704_31580_s4x3_lg.jpg"]

      end

      context 'with a cooks note' do
        strategy_subject_for('http://www.cookingchanneltv.com/recipes/debi-mazar-and-gabriele-corcos/limoncello-spritzer-recipe/index.html')

        it_should_find 'steps', [
          [
            "Add the raspberries to a food processor and puree until smooth. Strain the raspberries through a fine mesh sieve into a pitcher. Stir in the limoncello and prosecco. Garnish with more berries. Serve in ice filled glasses if desired."
          ]
        ]

        it_should_find 'notes', 'Add the prosecco right before serving.'

      end

      context 'with nutritional info' do
        strategy_subject_for('http://www.cookingchanneltv.com/recipes/healthy-french-toast-recipe/index.html')

        it_should_find 'steps', [
          [
            "Preheat the oven to 200 degrees F.",
            "In a pie plate, beat the egg whites, egg, milk, salt and vanilla with a whisk until blended. In a 12-inch nonstick skillet, melt 1 teaspoon butter or trans-fat-free margarine on medium heat.",
            "Dip the bread slices, one at a time, in the egg mixture, pressing the bread lightly to coat both sides well. Place 3 or 4 slices in the skillet, and cook until lightly browned, 3 to 4 minutes. Flip and cook until lightly browned on the second side, 3 to 4 minutes.",
            "Transfer the French toast to a cookie sheet; keep warm in the oven. Repeat with remaining butter or margarine, bread slices and egg mixture.",
            "1/2 cup berries and 1 tablespoon maple syrup. 384 complete meal calories."
          ]
        ]

      end

    end

  end

end