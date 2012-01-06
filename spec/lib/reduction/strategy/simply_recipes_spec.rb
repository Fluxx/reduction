# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe SimplyRecipes do
      use_vcr_cassette 'simply_recipes', tag: :base64_response_body

      describe 'for_url?' do

        it 'returns true for any food52.com URL' do
          described_class.for_url?('http://simplyrecipes.com/').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://www.sr.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://simplyrecipes.com/recipes/blue_cheese_burgers/')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'title', 'Blue Cheese Burgers Recipe'
        
        it_should_find 'yields', 'Makes 4 burgers'
        
        it_should_find 'ingredients', [
          [
            "1 pound ground beef (16-20%)",
            "1 Tbsp Dijon mustard",
            "2 cloves minced garlic",
            "2 green onions, chopped",
            "1/2 cup (about 2 ounces) crumbled blue cheese (get Pt. Reyes blue cheese if you can find it)",
            "1 egg",
            "1 Tbsp water",
            "Salt and freshly ground black pepper"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "1 Put ground beef, mustard, garlic, onions, blue cheese, water, egg, and a sprinkling of salt and pepper into a large bowl.  Use your hands to gently mix the ingredients together until just incorporated.  Do not over-mix.  Shape into patties, about 1/2  inch thick and larger than your bun.   Chill until you are ready to cook.  ",
            "2 Prepare charcoal or gas grill for cooking over high direct heat.  Using tongs and a folded up paper towel dipped in vegetable oil, oil the grill grates. Make sure grill is hot and well oiled before laying down the patties.   Season patties with salt and pepper.  Place the patties on the clean, well-oiled grill grate. Grill the burgers for about 5 minutes per side.  Do not press down on the burgers while cooking.  ",
            "If you don't have a grill, you can use a grill pan or a cast iron frying pan for the burgers.",
            "Serve on hamburger buns with lettuce and mayonnaise."
          ]
        ]

        it_should_find 'prep_time', nil
        it_should_find 'cook_time', nil
        
        it_should_find 'images', [
          "http://www.elise.com/recipes/photos/garrett-with-ground-beef.jpg",
          "http://www.elise.com/recipes/photos/blue-cheese-burger-1.jpg",
          "http://www.elise.com/recipes/photos/blue-cheese-burger-2.jpg",
          "http://www.elise.com/recipes/photos/blue-cheese-burger-3.jpg",
          "http://www.elise.com/recipes/photos/blue-cheese-burger-4.jpg"
       ]

        it_should_find 'notes', %q|Here's a tip, although you might be tempted to go with extra lean hamburger meat for this burger, given all the cheese, I don't recommend it, unless you want blue cheese flavored dry burgers.|

      end

      context 'split ingredient list' do
        strategy_subject_for('http://simplyrecipes.com/recipes/braised_lamb_shanks/')

        it_should_behave_like 'a strategy', :blessed

        it_should_find 'ingredients', [
          [
            "2 Lamb shanks",
            "Salt",
            "2 tablespoons olive oil",
            "1 medium yellow onion, chopped",
            "2 large carrots, chopped",
            "2 celery stalks, chopped",
            "3-4 medium potatoes, cut into 2-inch chunks",
            "1 garlic clove, minced",
            "1 1/4 cup stock or boiling water with a bullion cube",
            "2 teaspoons fresh thyme, or 1 teaspoon dried",
            "1 teaspoon fresh rosemary, chopped, or 1/2 teaspoon dried",
            "1 teaspoon dried oregano",
            "1 bay leaf"
          ],
          [
            "3/4 cup raisins, soaked in 1/2 cup sherry for a couple hours",
            "1/2 cup of fresh mint leaves"
          ]
        ]

        it 'finds the 2nd list name' do
          subject.ingredients.last.name.should == 'Optional, and highly recommended'
        end

      end

      context 'with a prep and cook time' do
        strategy_subject_for('http://simplyrecipes.com/recipes/classic_rack_of_lamb/')

        it_should_behave_like 'a strategy', :blessed

        it_should_find 'prep_time', '1 hour'
        it_should_find 'cook_time', '15 minutes'
      end

      context 'with a non-descript yields' do
        strategy_subject_for('http://simplyrecipes.com/recipes/herb_marinated_braised_lamb_shanks/')

        it_should_behave_like 'a strategy', :blessed
        it_should_find 'yields', 'Serves 4'

        it 'does not include the yield in the steps' do
          subject.steps.first.last.should_not =~ /Serves 4/
        end
      end
        
    end

  end

end