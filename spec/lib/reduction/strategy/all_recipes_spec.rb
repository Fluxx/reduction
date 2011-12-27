require 'spec_helper'

module Reduction
  class Strategy

    describe AllRecipes do
      use_vcr_cassette 'all_recipes'

      strategy_subject_for('http://allrecipes.com/Recipe/sopapilla-cheesecake-pie/Detail.aspx')

      it_should_behave_like "a strategy"

      describe 'for_url?' do

        it 'returns true for any allrecipes.com URL' do
          described_class.for_url?('http://allrecipes.com').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://www.example.com').should be_false
        end

      end

      it_should_find 'title', 'Sopapilla Cheesecake Pie Recipe'

      it_should_find 'ingredients', [
        [
          '2 (8 ounce) packages cream cheese, softened',
          "1 cup white sugar",
          '1 teaspoon Mexican vanilla extract',
          '2 (8 ounce) cans refrigerated crescent rolls',
          '3/4 cup white sugar',
          '1 teaspoon ground cinnamon',
          '1/2 cup butter, room temperature',
          '1/4 cup honey'
        ]
      ]

      it_should_find 'steps', [
        [
          'Preheat an oven to 350 degrees F (175 degrees C). Prepare a 9x13 inch baking dish with cooking spray.',
          'Beat the cream cheese with 1 cup of sugar and the vanilla extract in a bowl until smooth.',
          'Unroll the cans of crescent roll dough, and use a rolling pin to shape each piece into 9x13 inch rectangles. Press one piece into the bottom of a 9x13 inch baking dish. Evenly spread the cream cheese mixture into the baking dish, then cover with the remaining piece of crescent dough. Stir together 3/4 cup of sugar, cinnamon, and butter. Dot the mixture over the top of the cheesecake.',
          'Bake in the preheated oven until the crescent dough has puffed and turned golden brown, about 30 minutes. Remove from the oven and drizzle with honey. Cool completely in the pan before cutting into 12 squares.'
        ]
      ]

      it_should_find 'yields', '1 - 9x13 inch cheesecake'

      it_should_find 'prep_time', '15 Min'

      it_should_find 'cook_time', '45 Min'

      it_should_find 'images', [
        'http://images.media-allrecipes.com/site/allrecipes/area/community/userphoto/small/194206.jpg'
      ]

      describe '#title' do

        it 'does not contain "apprecipes.com"' do
          subject.title.should_not =~ /allrecipes/i
        end

      end

      describe 'with titled ingredient lists' do
        strategy_subject_for('http://allrecipes.com/recipe/ricotta-gnocchi/detail.aspx')

        it_should_behave_like 'a strategy'

        it_should_find 'ingredients', [
          [
            "1 (8 ounce) container ricotta cheese",
            "2 eggs",
            "1/2 cup freshly grated Parmesan cheese",
            "1 teaspoon salt",
            "1 teaspoon pepper",
            "1 teaspoon garlic powder",
            "1 cup all-purpose flour, or as needed"
          ],
          [
            "3 tablespoons olive oil",
            "1 tablespoon minced garlic",
            "1 (15.5 ounce) can diced tomatoes",
            "1 dash crushed red pepper flakes (optional)",
            "6 basil leaves, finely shredded",
            "Salt and pepper to taste",
            "8 ounces fresh mozzarella cheese, cut into small chunks"
          ]
        ]

        it 'finds the right list names' do
          subject.ingredients[0].name.should == 'Gnocchi'
          subject.ingredients[1].name.should == 'Sauce'
        end
      end

    end

  end
end