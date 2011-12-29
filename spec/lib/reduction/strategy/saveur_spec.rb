# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Saveur do
      use_vcr_cassette 'saveur'

      context 'for a normal recipe' do
        strategy_subject_for('http://www.saveur.com/article/Recipes/Rainbow-Cookies')

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any chow.com URL' do
            described_class.for_url?('http://www.saveur.com/').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.foody.com').should be_false
          end

        end

        it_should_find 'title', 'Rainbow Cookies'

        it_should_find 'ingredients', [
          [
            "1 ½ cups unsalted butter, softened, plus more for pans",
            "2 cups flour, plus more for pans",
            "1 cup sugar",
            "1 12.5-oz. can almond pastry filling, such as Solo brand",
            "4 eggs",
            "12 drops green food coloring",
            "12 drops red food coloring",
            "1 12-oz. seedless raspberry jam",
            "12 oz. semisweet chocolate, melted"
          ]
        ]

        it_should_find 'steps', [
          [
            "Heat oven to 350°. Grease and flour three 9″ x 13″ baking pans and line with parchment paper; set aside. Using a hand mixer on high speed, beat butter and sugar in a bowl until pale and fluffy, about 2 minutes. Add pastry filling; beat until smooth. Add eggs one at a time, beating well after each addition. Add flour; beat until just combined. Evenly divide batter into 3 bowls. Add green food coloring to one bowl, red food coloring to the second bowl, and leave the third bowl plain; stir colorings into batters. Using an offset spatula, spread each batter into a prepared baking pan. Bake each pan until just beginning to brown, about 10 minutes. Invert cakes onto wire racks; cool.",
            "Heat jam in a 1-qt. saucepan over medium heat; cook, stirring, until smooth; cool slightly. Place green cake on a cutting board or foil-lined baking sheet. Using an offset spatula, spread half the jam over green cake; top with plain cake. Spread remaining jam over plain cake; top with red cake. Chill cakes to set jam, 1 hour.",
            "Using a slicing knife, trim cake edges to form an even block. Slice block crosswise into 1 ½″-wide logs; separate on a cutting board. Using an offset spatula, spread chocolate over top, sides, and ends of each log until completely covered; chill to set chocolate. Slice each log crosswise into ½″-thick squares to serve."
          ]
        ]

        it_should_find 'yields', 'Makes about 10 dozen'

        it_should_find 'prep_time', nil

        it_should_find 'cook_time', nil

        it_should_find 'total_time', nil

        it_should_find 'images', ['http://www2.worldpub.net/images/saveurmag/7-SAV143-rainbowcookies-400x585.jpg']
      end

    end

  end

end