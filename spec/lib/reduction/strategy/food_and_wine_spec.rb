# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe FoodAndWine do
      use_vcr_cassette 'food_and_wine'

      context 'for a normal recipe' do
        strategy_subject_for('http://www.foodandwine.com/recipes/sherried-mushrooms-with-fried-eggs-on-toast')

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any chow.com URL' do
            described_class.for_url?('http://www.foodandwine.com').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.foody.com').should be_false
          end

        end

        it_should_find 'title', 'Sherried Mushrooms with Fried Eggs on Toast'

        it 'does not include chow in the title' do
          subject.title.should_not =~ /Food & Wine/i
        end

        it_should_find 'ingredients', [
          [
            "2 tablespoons extra-virgin olive oil, plus more for brushing",
            "3/4 pound mixed mushrooms, such as button and cremini, sliced 1/4 inch thick",
            "Salt and freshly ground pepper",
            "1/2 small onion, thinly sliced",
            "1/4 cup dry sherry, such as Oloroso",
            "Four 1/2-inch-thick slices of rustic white bread",
            "2 tablespoons unsalted butter",
            "4 large eggs",
            "2 tablespoons coarsely chopped flat-leaf parsley"
          ]
        ]

        it_should_find 'steps', [
          [
            "Preheat the oven to 400°. In a large skillet, heat the 2 tablespoons of oil until shimmering. Add the mushrooms and season with salt and pepper. Cover and cook over moderate heat, stirring a few times, until softened, 4 minutes. Add the onion, cover and cook, stirring occasionally, until the onion is softened and the mushrooms are browned, 3 minutes longer. Add the sherry and cook until almost evaporated, 1 minute. Season with salt and pepper. Remove from the heat, cover and set aside.",
            "Arrange the bread slices on a large rimmed baking sheet and brush with olive oil. Bake for about 6 minutes, until toasted. Transfer the toasts to plates.",
            "In a large, nonstick skillet, melt the butter over moderate heat. Crack the eggs one at a time into a ramekin and then slip into the skillet. Cook the eggs, sunny-side up, until the whites are firm and the yolks runny, about 5 minutes.",
            "Spoon the mushroom mixture onto the toasts and top with the fried eggs. Garnish with the parsley and serve."
          ]
        ]

        it_should_find 'yields', '4 servings'

        it_should_find 'prep_time', nil

        it_should_find 'cook_time', '35 min'

        it_should_find 'total_time', '35 min'

        it_should_find 'images', ["http://www.foodandwine.com/images/sys/200904-r-mushroom-eggs.jpg"]
      end

    end

  end

end