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

        it_should_find 'notes', 'My mother used to make these cookies regularly when I was growing up, and they continue to be the standard to which I compare all other peanut butter cookies. This recipe is adapted from one of my favorite cookbooks, The Fannie Farmer Cookbook (First Edition).'

      end

      context 'multiple ingredient lists' do

        strategy_subject_for('http://food52.com/recipes/15023_spiced_maple_pecan_pie_with_star_anise')

        it_should_find 'ingredients', [
          [
            "1 1/4 cup all-purpose flour",
            "1/4 teaspoon salt",
            "10 tablespoons unsalted butter, chilled and cut into ½-inch pieces",
            "2 to 5 tablespoons ice water"
          ],
          [
            "1 cup maple syrup",
            "1/2 cup Demerara or raw sugar",
            "8 whole star anise",
            "2 cups pecan halves",
            "3 large eggs",
            "4 tablespoons (1/2 stick) unsalted butter, melted",
            "2 tablespoons dark aged rum",
            "1/4 teaspoon kosher salt",
            "Whipped crème fraiche, for serving"
          ]
        ]

        it 'finds appropriate names for the ingredients' do
          subject.ingredients[0].name.should == 'For the piecrust'
          subject.ingredients[1].name.should == 'For the filling'
        end

        it_should_find 'steps', [
          [
            "To make the crust, in a food processor, briefly pulse together the flour and salt. Add the butter and pulse until the mixture forms lima bean-size pieces (three to five 1-second pulses). Add ice water 1 tablespoon at a time, and pulse until the mixture is just moist enough to hold together. Form the dough into a ball, wrap with plastic, and flatten into a disc. Refrigerate at least 1 hour before rolling out and baking (up to a week, or freeze for up to 4 months).",
            "On a lightly floured surface, roll out the piecrust to a 12-inch circle. Transfer the crust to a 9-inch pie plate. Fold over any excess dough, then crimp as decoratively as you can manage.",
            "Prick the crust all over with a fork. Freeze the crust for 15minutes or refrigerate for 30 minutes. Preheat the oven to 400°F. Cover the pie with aluminum foil and fill with pie weights (you can use pennies, rice, or dried beans for this; I use pennies). Bake for 20 minutes; remove the foil and weights and bake until pale golden, about 5 minutes more. Cool on a rack until needed.",
            "To make the filling, in a medium saucepan over medium-high heat, bring the maple syrup, sugar, and star anise to a boil. Reduce to a simmer and cook until the mixture is very thick, all the sugar has dissolved, and the syrup measures 1 cup, 15 to 20 minutes. Remove from the heat and let sit for 1 hour for the anise to infuse.",
            "While the syrup is infusing, toast the nuts. Preheat the oven to 325°. Spread the pecans out on a baking sheet and toast them in the oven until they start to smell nutty, about 12 minutes. Transfer to a wire rack to cool.",
            "Remove the star anise from the syrup. Warm the syrup if necessary to make it pourable but not hot (you can pop it in the microwave for a few seconds if you’ve moved it to a measuring cup). Do not stir the syrup as you reheat it, as it may crystallize and harden. In a medium bowl, whisk together the syrup, eggs, melted butter, rum, and salt. Fold in the pecan halves. Pour the filling into the crust and transfer to a rimmed baking sheet. Bake until the pie is firm to the touch but jiggles slightly when moved, 35 to 40 minutes. Let coo to room temperature before serving with whipped crème fraiche."
          ]
        ]

        it_should_find 'yields', 'Serves 8'

      end

      context 'mutliple steps and ingredient lists' do
        strategy_subject_for('http://food52.com/recipes/14948_judy_rodgers_roasted_applesauce_and_savory_apple_charlottes')

        it_should_find 'ingredients', [
          [
            "3 1/2 to 4 pounds apples (Rodgers uses crisp eating apples, like Sierra Beauties, Braeburns, Pippins, Golden Delicious or Galas)",
            "Pinch of salt",
            "Up to 2 teaspoons sugar, as needed",
            "About 2 tablespoons unsalted butter",
            "A splash of apple cider vinegar, as needed"
          ],
          [
            "A chunk of day-old, chewy, peasant-style bread (4 ounces or more -- you won't use more than 2 ounces, but you need plenty to work with in order to get the right shapes)",
            "About 2 to 3 tablespoons unsalted butter, melted",
            "About 1 1/3 cups Roasted Applesauce"
          ]
        ]

        it 'finds correct names for the ingredients' do
          subject.ingredients[0].name.should == 'Roasted Applesauce'
          subject.ingredients[1].name.should == 'Savory Apple Charlottes'
        end

        it_should_find 'steps', [
          [
            "Heat oven to 375 F.",
            "Peel, core, and quarter the apples. Toss with a little salt and, unless they are very sweet, a bit of sugar to taste. If they are tart enough to make you squint, add the full measure of sugar. Spread in a shallow baking dish that crowds the apples in a single layer. Drape with slivers of the butter, cover tightly with a lid or aluminum foil, and bake until the apples start to soften, 15 to 30 minutes, depending on your apples.",
            "Uncover, raise the heat to 500 F, and return the pan to the oven. Leave the apples to dry out and color slightly, about 10 minutes.",
            "When the tips of the apples have become golden and the fruit is tender, scrape them into a bowl and stir into a chunky \"mash. \"Season with salt and sugar to taste, then consider a splash of apple cider vinegar to brighten the flavor. (Try a drop on a spoonful to see if you like it.)",
            "You can stop here or go on to make the Savory Apple Charlottes."
          ],
          [
            "Note: Make these ramekins in straight-sided 6-ounce ramekins or custard cups. Heat oven to 350 F.",
            "Slice the bread 1/8 inch thick. (Partially freeze if necessary to get even slices.) Avoiding the crust, cut 8 circles sized to fit the bottom of your custard cups, then cut 4 long rectangles to line the sides. Kitchen shears work well for this. The side piece should rise about 1/8 inch above the rims. (You can cut paper templates first to make this easy, but it's pretty forgiving.) A snug fit and even edges will make your charlottes prettiest. (Save scraps and rejects for croutons or bread crumbs.)",
            "Brush the bread evenly, on one side only, with the melted butter. Line the custard cups with the bread, pressing the buttered faces against the dishes. Set the 4 extra circles aside. Fill each cup with roasted applesauce. Set the remaining bread circles, buttered side up, on top, held in place by the surrounding bread. Press down lightly.",
            "Bake until golden brown on top, about 30 minutes. To serve, slide a knife around the edge of each charlotte, then turn out onto warm plates. If the bottom circles stick to the dish, retrieve them by sliding a salad fork under the edges. The charlottes should be golden brown all over, with tasty caramelized spots where the applesauce bled through the coarse-textured bread."
          ]
        ]

      end

      context 'with multiple notes' do
        strategy_subject_for('http://food52.com/recipes/10579_best_boston_baked_beans')

        it 'only pulls the cooks notes' do
          subject.notes.should == 'As a native Bostonian living on the West Coast, I sometimes get homesick for baked beans. This is a recipe I made for an heirloom variety called Ireland Creek Annie beans, a lovely golden legume that hold up well during cooking, but this dish would work well with a number of beans including small navy beans or anasazi. The key for creating a rich, syrupy dish is to bake the beans on low heat in the oven, and then raise the temperature and removing the lid for the last half hour so the liquid reduces and the beans develop some charred flavors. - Fairmount_market'
        end
      end
        
    end

  end

end