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
          '1 medium head cauliflower',
          '1 tablespoon cream cheese, softened',
          '1/4 cup grated Parmesan',
          '1/2 teaspoon minced garlic',
          '1/8 teaspoon straight chicken base or bullion (may substitute 1/2 teaspoon salt)',
          '1/8 teaspoon freshly ground black pepper',
          '1/2 teaspoon chopped fresh or dry chives, for garnish',
          '3 tablespoons unsalted butter'
        ]

        it_should_find 'steps', [
          'Set a stockpot of water to boil over high heat.',
          'Clean and cut cauliflower into small pieces. Cook in boiling water for about 6 minutes, or until well done. Drain well; do not let cool and pat cooked cauliflower very dry between several layers of paper towels.',
          'In a bowl with an immersion blender, or in a food processor, puree the hot cauliflower with the cream cheese, Parmesan, garlic, chicken base, and pepper until almost smooth.',
          'Garnish with chives, and serve hot with pats of butter.',
          'Hint: Try roasting the garlic and adding a little fresh rosemary for a whole new taste.',
          'Chef: George Stella'
        ]

        it_should_find 'yields', '4 servings'

        it_should_find 'prep_time', '15 min'

        it_should_find 'cook_time', '6 min'
      end
      
      context 'a recipe with multiple ingredient lists' do
        subject { described_class.new(get_page('http://www.foodnetwork.com/recipes/alexandra-guarnaschelli/simple-birthday-cake-with-marshmallow-frosting-recipe/index.html')) }
        it_should_behave_like "a strategy"
        # TODO: specific checks
      end
        
      context 'a recipe with multiple step lists' do
        subject { described_class.new(get_page('http://www.foodnetwork.com/recipes/alexandra-guarnaschelli/simple-birthday-cake-with-marshmallow-frosting-recipe/index.html')) }
        it_should_behave_like "a strategy"
        # TODO: specific checks
      end
      


    end

  end

end