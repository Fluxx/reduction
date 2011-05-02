require 'spec_helper'

module Reduction
  class Strategy

    describe FoodNetwork do

      subject { described_class.new(fixture(:food_network)) }

      it_should_behave_like "a strategy"

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

  end

end