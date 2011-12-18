# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Food52 do
      use_vcr_cassette 'food52'

      describe 'for_url?' do

        it 'returns true for any food52.com URL' do
          described_class.for_url?('http://food52.com').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://foodfiftytwo.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://food52.com/recipes/15242_peanut_butter_cookies')

        it_should_behave_like "a strategy"

        it_should_find 'title', 'Peanut Butter Cookies'
        
        it_should_find 'yields', 'Makes about 4 dozen cookies'
        
        it_should_find 'ingredients', [
          [
            "1/2 cup softened unsalted butter",
            "1/2 cup creamy peanut butter (not the unsweetened kind)",
            "1/2 cup sugar",
            "1/2 cup light brown sugar",
            "1 large egg",
            "1/2 teaspoon vanilla extract",
            "1/2 teaspoon kosher salt",
            "1/2 teaspoon baking soda",
            "1 cup all-purpose flour"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "Heat the oven to 350 degrees F. In the bowl of a standing mixer fitted with the paddle attachment, or using a hand blender, cream together the butter and peanut butter. Beat in the two sugars until light, about 3 minutes.",
            "Beat in the egg and vanilla, scraping down the sides of the bowl once to make sure they're evenly incorporated. Add the salt, baking soda and flour and beat just until combined.",
            "Give the dough one last fold with a spatula. You can chill the dough and then roll it into balls (about 3/4-inch in diameter), or arrange heaping teaspoonfuls of the soft dough directly on parchment-lined baking sheets, spaced 2 inches apart. Use the back of a fork dipped in flour to gently flatten each cookie and make a crosshatch pattern",
            "Bake the cookies for about 10 minutes, until lightly golden and just firm around the edges. Let them cool on the baking sheets for a few minutes, then transfer to a baking rack to cool completely. These will keep in an airtight container for several days, but they are best while fresh!"
          ]
        ]

        it_should_find 'prep_time', nil
        it_should_find 'cook_time', nil
        
        it_should_find 'images', [
          "http://s3.amazonaws.com/food52_assets/indeximages/22863/nine_col/Food52_11-22-11-0899.jpg?1322800208"
        ]

      end
        
    end

  end

end