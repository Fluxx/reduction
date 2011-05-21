require 'spec_helper'

module Reduction
  class Strategy

    describe FoodNetwork do

      use_vcr_cassette 'food_network'

      context 'a normal recipe' do
        subject { described_class.new(get_page('http://www.foodnetwork.com/recipes/george-stella/mock-garlic-mashed-potatoes-recipe/index.html')) }

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any www.foodnetwork.com URL' do
            described_class.for_url?('http://www.foodnetwork.com').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.foodtv.com').should be_false
          end

        end

        it_should_find 'title', %Q{"Mock" Garlic Mashed Potatoes}

        it 'does not include Food Network in the title' do
          subject.title.should_not =~ /food network/i
        end

        it_should_find 'ingredients', [
          [
            '1 medium head cauliflower',
            '1 tablespoon cream cheese, softened',
            '1/4 cup grated Parmesan',
            '1/2 teaspoon minced garlic',
            '1/8 teaspoon straight chicken base or bullion (may substitute 1/2 teaspoon salt)',
            '1/8 teaspoon freshly ground black pepper',
            '1/2 teaspoon chopped fresh or dry chives, for garnish',
            '3 tablespoons unsalted butter'
          ]
        ]

        it_should_find 'steps', [
          [
            'Set a stockpot of water to boil over high heat.',
            'Clean and cut cauliflower into small pieces. Cook in boiling water for about 6 minutes, or until well done. Drain well; do not let cool and pat cooked cauliflower very dry between several layers of paper towels.',
            'In a bowl with an immersion blender, or in a food processor, puree the hot cauliflower with the cream cheese, Parmesan, garlic, chicken base, and pepper until almost smooth.',
            'Garnish with chives, and serve hot with pats of butter.',
            'Hint: Try roasting the garlic and adding a little fresh rosemary for a whole new taste.',
            'Chef: George Stella'
          ]
        ]

        it_should_find 'yields', '4 servings'

        it_should_find 'prep_time', '15 min'

        it_should_find 'cook_time', '6 min'
      end

      context 'a recipe with multiple ingredient lists' do
        subject { described_class.new(get_page('http://www.foodnetwork.com/recipes/alexandra-guarnaschelli/simple-birthday-cake-with-marshmallow-frosting-recipe/index.html')) }
        it_should_behave_like "a strategy"

        it_should_find 'ingredients', [
          [
            "10 tablespoons unsalted butter, plus additional for cake pans",
            "1/2 teaspoon baking soda",
            "1 teaspoon kosher salt",
            "1 1/2 teaspoons baking powder",
            "2 1/2 cups all-purpose flour",
            "2 eggs",
            "1 1/3 cups granulated sugar",
            "2 teaspoons vanilla extract",
            "2 cups sour cream",
            "1 1/2 cups coarsely chopped semisweet chocolate"
          ],
          [
            "5 tablespoons cool water, plus more for the double boiler",
            "1/4 teaspoon cream of tartar",
            "1 1/3 cups granulated sugar",
            "2 egg whites, room temperature",
            "1 tablespoon light corn syrup",
            "1 teaspoon vanilla extract"
          ]
        ]

        it 'grabs the right headers' do
          subject.ingredients.map(&:name).should == [nil, '"Marshmallowy" Frosting:']
        end
      end

      context 'a recipe with multiple step lists' do
        subject { described_class.new(get_page('http://www.foodnetwork.com/recipes/alexandra-guarnaschelli/simple-birthday-cake-with-marshmallow-frosting-recipe/index.html')) }
        it_should_behave_like "a strategy"

        it_should_find 'steps', [
          [
            "Special equipment: 2 (8 by 2-inch) round cake pans and an instant-read thermometer",
            "Cake:",
            "Preheat the oven to 350 degrees F.",
            "Liberally butter the bottom and sides of 2 cake pans.  Put a round of parchment paper into the bottom of each pan and coat them with butter.  Put the pans on a baking sheet.",
            "Melt the 10 tablespoons of butter in a small pot over low heat. Remove the pot from the stove and allow it to cool slightly. Reserve.",
            "In a medium bowl, sift together the baking soda, salt, baking powder and flour.",
            "In a large bowl, beat the eggs, sugar, vanilla, and sour cream together until smooth. Add the flour mixture in small batches to the wet ingredients, whisking as you go to avoid the formation of lumps. Make a well in the center of the batter and pour in the melted butter. Whisk until smooth. Fold in the chopped chocolate",
            "Divide the batter between the cake pans and spread out to level the top. Gently tap the sides of the pan so the batter distributes evenly. Slide the baking sheet into the center of the oven and bake until a toothpick inserted in the center comes out clean, 40 to 45 minutes. Remove the pans from the oven and allow the cakes to cool briefly. Invert the cakes from the pans onto a baking sheet fitted with a wire rack and peel off the parchment paper. Allow them to cool for at least 45 minutes before frosting.",
            "Frosting:",
            "Pour some water, about 2 inches deep, into a saucepan to create a makeshift double boiler. Put the pan on the stove and bring the water to a gentle simmer. Dip the instant-read thermometer into the simmering water to clean any impurities off the end and to test that the thermometer works.",
            "In a clean, large mixing bowl, combine the 5 tablespoons of cool water, cream of tartar, sugar, egg whites and corn syrup. Gently lower the bowl over the simmering water. Turn off the heat under the pot. Use an electric hand beater to whip the whites over the water. Do not leave the egg white mixture unattended or stop beating any time during this process.",
            "After about 3 minutes, remove the bowl from the heat, set the beater down and quickly take the temperature of the egg whites. You want them to reach 140 degrees F. If you measure the temperature before they reach that point, immediately put the bowl of whites back over the water and resume beating until they are finished, an additional 2 to 3 minutes.",
            "Remove the bowl from the water and fold in the vanilla extract. It should look like marshmallow fluffiness. Set the frosting aside to allow the mixture to cool. Frost the cake by, as my father used to say, \"glopping\" the frosting all over the top and the sides. Serve immediately."
            ]
          ]
      end



    end

  end

end