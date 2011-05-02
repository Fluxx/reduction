require 'spec_helper'

module Reduction
  class Strategy

    describe AllRecipes do

      subject { described_class.new(fixture(:all_recipes)) }

      describe '#title' do

        it 'returns the title of the specified recipe' do
          subject.title.should == "Sopapilla Cheesecake Pie Recipe"
        end

        it 'does not contain "apprecipes.com"' do
          subject.title.should_not =~ /allrecipes/i
        end

      end

      describe '#ingredients' do

        it 'returns an array of ingredients' do
          subject.ingredients.should == [
            '2 (8 ounce) packages cream cheese, softened',
            "1 cup white sugar",
            '1 teaspoon Mexican vanilla extract',
            '2 (8 ounce) cans refrigerated crescent rolls',
            '3/4 cup white sugar',
            '1 teaspoon ground cinnamon',
            '1/2 cup butter, room temperature',
            '1/4 cup honey'
          ]
        end

      end

      describe '#steps' do

        it 'returns an array of directions' do
          subject.steps.should == [
            'Preheat an oven to 350 degrees F (175 degrees C). Prepare a 9x13 inch baking dish with cooking spray.',
            'Beat the cream cheese with 1 cup of sugar and the vanilla extract in a bowl until smooth.',
            'Unroll the cans of crescent roll dough, and use a rolling pin to shape each piece into 9x13 inch rectangles. Press one piece into the bottom of a 9x13 inch baking dish. Evenly spread the cream cheese mixture into the baking dish, then cover with the remaining piece of crescent dough. Stir together 3/4 cup of sugar, cinnamon, and butter. Dot the mixture over the top of the cheesecake.',
            'Bake in the preheated oven until the crescent dough has puffed and turned golden brown, about 30 minutes. Remove from the oven and drizzle with honey. Cool completely in the pan before cutting into 12 squares.'
          ]
        end

      end

      describe '#yields' do

        it 'returns the amount of food this recipe makes' do
          subject.yields.should == '1 - 9x13 inch cheesecake'
        end

      end

      describe '#prep_time' do

        it 'returns the prep time' do
          subject.prep_time.should == '15 Min'
        end

      end

      describe '#cook_time' do

        it 'returns the cook time' do
          subject.cook_time.should == '45 Min'
        end

      end

    end

  end
end