require 'spec_helper'

module Reduction
  class Strategy

    describe FoodNetwork do

      use_vcr_cassette 'food_network'

      context 'a normal recipe' do
        strategy_subject_for('http://www.foodnetwork.com/recipes/george-stella/mock-garlic-mashed-potatoes-recipe/index.html')

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
        strategy_subject_for('http://www.foodnetwork.com/recipes/alexandra-guarnaschelli/simple-birthday-cake-with-marshmallow-frosting-recipe/index.html')
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
        strategy_subject_for('http://www.foodnetwork.com/recipes/giada-de-laurentiis/hazelnut-crunch-cake-with-mascarpone-and-chocolate-recipe/index.html')
        it_should_behave_like "a strategy"

        it_should_find 'steps', [
          [
            "Preheat the oven to 350 degrees F.",
            "Butter and flour 2 (8-inch) cake pans. Prepare the cake mix according to package instructions. Divide the batter between the 2 cake pans and bake according to package instructions. Remove from the oven and let cool on a wire rack."
          ],
          [
            "Place the toasted nuts close together in a single layer on a parchment-lined baking sheet. Combine the sugar and water in a small saucepan over medium-high heat. Stir the sugar mixture until dissolved. Bring to a boil and let cook until the sugar is light brown, about 8 minutes. Let the bubbles subside then pour the caramelized sugar over the nuts. Place the baking sheet in the refrigerator and let the sugar nut mixture cool until hard, about 30 minutes. When the sugar nut mixture is hard and cool, top with another piece of parchment paper and pound into small pieces, or place the sugar nut mixture on a cutting board and cut into small pieces. Set aside."
          ],
          [
            "Put the mascarpone cheese, cream, powdered sugar, and vanilla into a large mixing bowl. Using an electric mixer whip the cream mixture to soft peaks. Fold the Crunch mixture into the whipped cream."
          ],
          [
            "Place the chocolate, sugar and zest in a food processor. Process the mixture until the chocolate is finely ground."
          ],
          [
            "Put 1 cake on a serving plate. Top with 1-inch of the whipped cream crunch mixture. Top with the second layer of cake and continue frosting the entire cake with the remaining whipped cream crunch mixture. Sprinkle the top and sides of the cake with the ground chocolate. Serve."
          ]
        ]
        
        it 'picks out the name of the lists' do
          subject.steps.map(&:name).should ==  [
            "Directions",
            "For the Crunch:",
            "For the filling:",
            "For the topping:",
            "To assemble the cake:"
          ] 
        end
      end

    end

  end

end