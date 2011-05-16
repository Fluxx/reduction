require 'spec_helper'

module Reduction
  class Strategy

    describe Epicurious do
      use_vcr_cassette 'epicurious'

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

  end
end