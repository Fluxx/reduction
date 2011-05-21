# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Epicurious do
      use_vcr_cassette 'epicurious'

      context 'normal recipe' do
        subject { described_class.new(get_page('http://www.epicurious.com/recipes/food/views/Patricia-Wellss-Cobb-Salad-Iceberg-Tomato-Avocado-Bacon-and-Blue-Cheese-364872')) }

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any www.epicurious.com URL' do
            described_class.for_url?('http://www.epicurious.com').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.epi.com').should be_false
          end

        end

        it_should_find 'title', 'Patricia Wells\'s Cobb Salad: Iceberg, Tomato, Avocado, Bacon, and Blue Cheese'

        it_should_find 'ingredients', [
          "2 1/2 ounces smoked bacon, rind removed, cut into matchsticks (3/4 cup)",
          "1 head iceberg lettuce, chopped (4 cups)",
          "2 ripe heirloom tomatoes, cored, peeled, seeded, and chopped",
          "1 large ripe avocado, halved, pitted, peeled, and cubed",
          "4 ounces chilled blue cheese (preferably Roquefort), crumbled (1 cup)",
          "4 small spring onions or scallions, white part only, trimmed, peeled, and cut into thin rounds",
          "Yogurt and Lemon Dressing",
          "Coarse, freshly ground black pepper"
        ]

        it_should_find 'steps', [
          "In a large, dry skillet, brown the bacon over moderate heat until crisp and golden, about 5 minutes. With a slotted spoon, transfer the bacon to several layers of paper towels to absorb the fat. Blot the top of the bacon with several layers of paper towels to absorb any additional fat. Set aside.",
          "In a large, shallow bowl, combine the bacon, lettuce, tomatoes, avocado, cheese, and spring onions. Toss with just enough dressing to lightly and evenly coat the ingredients. Season generously with pepper, and serve."
        ]

        it_should_find 'yields', '4 servings'

        it_should_find 'prep_time', nil

        it_should_find 'cook_time', nil
      end

      context 'a recipe with multiple ingredient lists' do
        subject { described_class.new(get_page('http://www.epicurious.com/recipes/food/views/Strawberry-Mascarpone-Tart-with-Port-Glaze-352272')) }
        it_should_behave_like "a strategy"

        it_should_find 'ingredients', [
          [
            "1 1/4 cups all-purpose flour",
            "3 tablespoons granulated sugar",
            "Rounded 1/4 teaspoon salt",
            "7 tablespoons unsalted butter, cut into 1/2-inch pieces",
            "1 large egg yolk",
            "1/2 teaspoon pure vanilla extract",
            "1/2 teaspoon fresh lemon juice",
            "3 tablespoons cold water"
          ],
          [
            "1 1/2 pounds strawberries (about 1 1/2 quarts), trimmed and halved lengthwise",
            "1/3 cup granulated sugar",
            "3/4 cup ruby Port",
            "1 pound mascarpone (about 2 cups)",
            "1/4 cup confectioners sugar",
            "1 teaspoon fresh lemon juice",
            "1/2 teaspoon grated lemon zest",
            "3/4 teaspoon pure vanilla extract"
          ]
        ]
      end

      context 'a recipe with multiple step lists' do
        subject { described_class.new(get_page('http://www.epicurious.com/recipes/food/views/Strawberry-Mascarpone-Tart-with-Port-Glaze-352272')) }
        it_should_behave_like "a strategy"

        it_should_find 'steps', [
          [
            "Blend together flour, sugar, salt, and butter in a bowl with your fingertips or a pastry blender (or pulse in a food processor) just until mixture resembles coarse meal with some roughly pea-size butter lumps. Beat together yolk, vanilla, lemon juice, and water with a fork, then drizzle over flour mixture and stir with fork (or pulse) until mixture comes together.",
            "Gently knead with floured hands on a lightly floured surface until a dough forms, then gently knead 4 or 5 times. Press into a 5-inch disk. Place in center of tart pan and cover with plastic wrap. Using your fingers and bottom of a flat-bottomed measuring cup, spread and push dough to evenly cover bottom and side of pan. Prick bottom of tart shell all over with a fork and freeze until firm, about 10 minutes.",
            "Preheat oven to 375°F with rack in middle.", "Line tart shell with foil and fill with pie weights. Bake until side is set and edge is pale golden, about 20 minutes. Carefully remove foil and weights and continue to bake until shell is deep golden all over, about 20 minutes more. Cool in pan, about 45 minutes."
          ],
          [
            "Stir together strawberries and granulated sugar in a bowl and let stand, stirring occasionally, 30 minutes. Strain in a sieve set over a small saucepan, reserving berries. Add Port to liquid in saucepan and boil until reduced to about 1/4 cup, 10 to 15 minutes. Transfer to a small bowl to cool slightly.",
            "Meanwhile, whisk together mascarpone, confectioners sugar, lemon juice, zest, vanilla, and a pinch of salt until stiff."
          ],
          [
            "Spread mascarpone mixture evenly in cooled tart shell, then top with strawberries. Drizzle Port glaze all over tart.",
            "Cooks' note: Tart shell can be baked 1 day ahead and kept at room temperature."
          ]
        ]

        it 'should extract out the steps names correctly' do
          subject.steps.map(&:name).should == [
            "Make tart shell:",
            "Make filling while tart shell cools:",
            "Assemble tart:"
          ]
        end
      end

      context 'a recipe with one step and random line breaks' do
        subject { described_class.new(get_page('http://www.epicurious.com/recipes/food/views/Lemongrass-Lime-Leaf-365192')) }
        it_should_behave_like "a strategy"

        it_should_find 'steps',  [
          "Combine citrus zest, lime leaves, lemongrass, and 2 cups water in a small saucepan. Bring to a boil, reduce heat, and simmer for 5 minutes. Strain lemongrass mixture into a jar and chill. Fill a 12 ounce glass with ice cubes. Add 2 tablespoons lemongrass mixture and 1 tablespoon simple syrup. Top with soda water (about 1/2 cup) and stir to combine. Repeat to make 11 more sodas."
        ]
      end

    end

  end
end