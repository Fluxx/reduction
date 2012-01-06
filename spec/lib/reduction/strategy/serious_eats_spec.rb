# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe SeriousEats do
      use_vcr_cassette 'serious_eats'

      describe 'for_url?' do

        it 'returns true for any food52.com URL' do
          described_class.for_url?('http://www.seriouseats.com').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://se.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://www.seriouseats.com/recipes/2011/11/real-texas-chili-con-carne.html?ref=box_featured')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'title', 'Real Texas Chili Con Carne'
        
        it_should_find 'yields', '6 to 8'
        
        it_should_find 'ingredients', [
          [
            "3 whole sweet fresh chilies like Costeño, New Mexico, or Choricero, stems and seeds removed",
            "2 small hot chilies like Arbol or Cascabel, stems and seeds removed",
            "2 whole Chipotle chilies canned in adobo sauce, plus 2 tablespoons sauce, stems and seeds removed",
            "3 whole rich fruity chilies like Ancho, Mulatto, Negro, or Pasilla, stems and seeds removed",
            "2 quarts low sodium canned or homemade chicken broth",
            "4 pounds beef chuck, trimmed of excess gristle and fat, cut into 2-inch chunks",
            "Kosher salt and freshly ground black pepper",
            "2 tablespoons vegetable oil",
            "1 large onion, finely diced",
            "4 medium cloves garlic, grated on a microplane grater",
            "1/2 teaspoon powdered cinnamon",
            "1 tablespoon ground cumin",
            "1/4 teaspoon ground allspice",
            "2 teaspoons dried oregano",
            "2 to 3 tablespoons masa"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "Combine all chilies in a medium saucepan and add half of chicken broth. Simmer over medium-high heat until chilies are completely tender, about 15 minutes. Transfer to a blender or hand blender cup and blend until completely smooth.",
            "Heat oil in a large heavy-bottomed Dutch oven over high heat until smoking. Season half of meat with salt and pepper and cook without moving until well-browned on bottom side, about 6 minutes. Transfer meat to a large bowl and combine with remaining un-cooked half of meat and set aside. Return Dutch oven to heat. Add onions and cook, stirring frequently until translucent and softened, about 2 minutes. Add garlic, cinnamon, cumin, allspice, and oregano, and cook, stirring constantly until fragrant, about 1 minute. Add all meat back to pan along with chili puree and remaining quart chicken broth. Stir to combine.",
            "Bring to a boil over high heat, reduce to a simmer, cover, leaving lid just barely ajar and cook, stirring occasionally until meat is completely tender, 2 1/2 to 3 hours. Alternatively, stew can be cooked in a 200° to 250°F oven with the lid of the Dutch oven slightly ajar.",
            "Season liquid to taste with salt and pepper and whisk in masa in a slow steady stream until desired thickness is reached. For best results, allow chili to cool overnight and reheat the next day to serve.",
            "Serve, garnished with cilantro, chopped onions, scallions, grated cheese, avocado, and warm tortillas as desired."
          ]
        ]

        it_should_find 'prep_time', '45 minutes'
        it_should_find 'cook_time', '3 hours'
        
        it_should_find 'images', [
          "http://www.seriouseats.com/recipes/images/2011/11/20111108-beef-texas-chili-con-carne-primary.jpg"
        ]

        it_should_find 'notes', 'This makes for a moderately hot to hot chili. You can vary the heat by adding or removing the hot chilies and the canned chipotles.'

      end

      context 'with no notes' do
        strategy_subject_for('http://www.seriouseats.com/recipes/2011/12/mushroom-lasagna-recipe.html?ref=box_featured')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'notes', nil
      end

      context 'with introduction text' do
        strategy_subject_for('http://www.seriouseats.com/recipes/2011/12/serious-eats-corned-beef-hash-recipe.html?ref=box_featured')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'notes', nil
      end
     
    end

  end

end