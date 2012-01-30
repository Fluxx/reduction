# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe MyRecipes do
      use_vcr_cassette 'my_recipes'

      describe 'for_url?' do

        it 'returns true for any my recipes URL' do
          described_class.for_url?('http://www.myrecipes.com/').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://mr.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://www.myrecipes.com/recipe/moroccan-chicken-butternut-squash-soup-50400000118582/')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'title', 'Moroccan Chicken and Butternut Squash Soup'
        
        it_should_find 'yields', 'Serves 4 (serving size: 1 1/2 cups)'
        
        it_should_find 'ingredients', [
          [
            "1 tablespoon olive oil",
            "1 cup chopped onion",
            "3 (4-ounce) skinless, boneless chicken thighs, cut into bite-sized pieces",
            "1 teaspoon ground cumin",
            "1/4 teaspoon ground cinnamon",
            "1/8 to 1/4 teaspoon ground red pepper",
            "3 cups (1/2-inch) cubed peeled butternut squash",
            "2 tablespoons no-salt-added tomato paste",
            "4 cups Chicken Stock or fat-free, lower-sodium chicken broth",
            "1/3 cup uncooked couscous",
            "3/4 teaspoon kosher salt",
            "1 zucchini, quartered lengthwise and sliced into 3/4-inch pieces",
            "1/2 cup coarsely chopped fresh basil",
            "2 teaspoons grated orange rind"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "Heat a Dutch oven over medium heat. Add oil to pan; swirl to coat. Add onion, and cook for 4 minutes, stirring occasionally. Add chicken; cook for 4 minutes, browning on all sides. Add cumin, cinnamon, and pepper to pan; cook 1 minute, stirring constantly. Add butternut squash and tomato paste; cook 1 minute. Stir in Chicken Stock, scraping pan to loosen browned bits. Bring to a boil. Reduce heat, and simmer 8 minutes. Stir in couscous, salt, and zucchini; cook 5 minutes or until squash is tender. Remove pan from heat. Stir in chopped basil and orange rind."
          ]
        ]

        it_should_find 'prep_time', nil
        it_should_find 'total_time', '48 Minutes'
        it_should_find 'cook_time', nil
        
        it_should_find 'images', [
          "http://img4.myrecipes.com/i/recipes/ck/12/01/moroccan-chicken-butternut-soup-ck-l.jpg"
        ]

        it_should_find 'notes', nil

      end

      context 'with split up ingredient sections' do
        strategy_subject_for('http://www.myrecipes.com/recipe/giant-butternut-squash-ravioli-10000001865411/')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'ingredients', [
          [
            "1 butternut squash (about 3 1/2 lbs.), peeled, seeded, and cut into 2-in. chunks",
            "1 tablespoon extra-virgin olive oil",
            "Salt and freshly ground black pepper",
            "3/4 cup ground toasted almonds",
            "1 tablespoon minced fresh sage",
            "4 ounces freshly grated parmesan cheese (1 3/4 cups)",
            "1/2 teaspoon freshly grated nutmeg"
          ],
          [
            "Fine semolina",
            "Fresh Pasta Dough, rolled into sheets as directed, or 2 lbs. purchased fresh ravioli or lasagna sheets",
            "1 qt. reduced-sodium chicken broth or homemade chicken broth",
            "2 tablespoons butter",
            "2 teaspoons extra-virgin olive oil",
            "1 tablespoon minced flat-leaf parsley",
            "Freshly grated parmesan cheese"
          ]
        ]

        it 'finds correct names' do
          subject.ingredients.map(&:name).should == ['Filling', 'Assembling & serving']
        end

      end
    end

  end

end