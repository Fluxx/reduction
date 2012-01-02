# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Chow do
      use_vcr_cassette 'chow'

      context 'normal recipe page' do

        strategy_subject_for('http://www.chow.com/recipes/29576-chocolate-dipped-vanilla-ice-cream-bars')

        it_should_behave_like "a strategy"

        describe 'for_url?' do

          it 'returns true for any chow.com URL' do
            described_class.for_url?('http://chow.com').should be_true
          end

          it 'returns false for any other URL' do
            described_class.for_url?('http://www.chowfoods.com').should be_false
          end

        end

        it_should_find 'title', 'Chocolate-Dipped Vanilla Ice Cream Bars Recipe'

        it 'does not include chow in the title' do
          subject.title.should_not =~ /CHOW/i
        end

        it_should_find 'ingredients', [
          [
            "2 pints (4 cups) premium or homemade vanilla ice cream, softened until just spreadable but not melted",
            "2 pounds milk chocolate couverture or coarsely chopped milk chocolate"
          ]
        ]

        it_should_find 'steps', [
          [
            "Line a 9-by-9-inch baking pan with plastic wrap, overlapping as needed to completely cover the bottom and sides and leaving at least a 5-inch overhang. (If possible, use a pan that does not have sloping sides.)",
            "Drop the ice cream in large dollops into the pan and spread to the edges with a rubber spatula. Cover with the overhanging plastic wrap and press on the surface of the ice cream with the bottom of a measuring cup until it’s packed into a smooth, even layer. Freeze until solid, at least 3 hours.",
            "Meanwhile, line 2 baking sheets with parchment or waxed paper. Tape each corner of the paper down and place the baking sheets in the freezer.",
            "When the ice cream is solid, remove the pan and 1 baking sheet from the freezer. Grasping the plastic wrap, pull the ice cream slab out of the pan and place it on a cutting board. Remove and discard the plastic wrap. Slice the slab into 9 even squares.",
            "Using a flat spatula, transfer and evenly space the squares on the baking sheet. Freeze until solid, at least 2 hours.",
            "Fill a large bowl with 2 inches of cold water, add 3 to 4 ice cubes, and set aside.",
            "Bring a medium saucepan filled with 1 to 2 inches of water to a simmer over high heat; once simmering, reduce the heat to low and maintain a bare simmer. Place 24 ounces of the chocolate in a large, dry, heatproof bowl. Set the bowl over the saucepan and stir with a rubber spatula until the chocolate is completely melted and has reached 118°F. (Make sure the chocolate does not come into contact with any water or exceed 120°F. If either happens, start over, as the chocolate is no longer usable.)",
            "Remove the bowl from the saucepan. Add the remaining 8 ounces of chocolate and stir constantly, scraping against the bottom of the bowl, until all of the chocolate has melted and the temperature has cooled to 80°F. To speed the cooling process, after all of the chocolate has melted you can place the bowl over the reserved cold-water bath.",
            "Return the bowl to the saucepan and stir until the chocolate reaches 86°F; immediately remove from heat. Do not remove the thermometer from the bowl; check the temperature periodically to make sure it stays between 85°F and 87°F. (The chocolate must remain in this temperature range or it will not set up properly.) Keep the saucepan over low heat and use it to reheat the chocolate as necessary.",
            "To test if the chocolate is properly tempered, spread a thin layer on parchment or waxed paper and place it in the refrigerator for 3 minutes to set. If the chocolate hardens smooth and without streaks, it is properly tempered. (If it is not properly tempered, let the melted chocolate harden and start the tempering process over again: Bring the chocolate up to 118°F, then down to 80°F, then up again to 86°F.)",
            "Have a fork and flat spatula ready. Remove the empty baking sheet and the baking sheet with the ice cream squares from the freezer. Working quickly, use the flat spatula to drop 1 ice cream square into the chocolate. Using the fork, flip the square, making sure the edges are covered in chocolate. Lift the square out of the chocolate with the fork and tap the fork several times on the edge of the bowl to even out the coating. Scrape the bottom of the fork against the edge of the bowl to remove any excess chocolate. Place the coated square on the empty baking sheet. Repeat with the remaining squares and chocolate, tilting the bowl as needed to pool the chocolate in one area, and spacing the squares as close together as possible on the baking sheet without touching. (If the ice cream squares start to melt, return them to the freezer until firm before continuing.)",
            "Freeze the dipped ice cream bars until the chocolate coating has hardened and the ice cream is solid, at least 2 hours. Wrap them individually in plastic wrap, then foil, and store in the freezer for up to 2 weeks."
          ]
        ]

        it_should_find 'yields', '9 (3-inch-square) bars'

        it_should_find 'prep_time', nil

        it_should_find 'cook_time', '45 mins, plus at least 7 hrs freezing time'

        it_should_find 'total_time', '45 mins, plus at least 7 hrs freezing time'

        it_should_find 'images', [
          "http://search.chow.com/thumbnail/480/0/www.chow.com//assets/2011/04/29576_chocolate_dipped_vanilla_ice_cream_bars_620.jpg",
          "http://www.chow.com/images/green_checkmark.png",
          "http://www.chow.com/assets/2011/04/vanilla_bar_1.jpg",
          "http://www.chow.com/assets/2011/04/vanilla_bar_2.jpg",
          "http://www.chow.com/assets/2011/04/vanilla_bar_3.jpg",
          "http://www.chow.com/assets/2011/04/vanilla_bar_4.jpg",
          "http://www.chow.com/assets/2011/04/vanilla_bar_5.jpg"
        ]

      end

      context 'recipe with multiple sets of ingredients' do

        strategy_subject_for('http://www.chow.com/recipes/29539-pavlova-with-lemon-curd-and-fresh-berries')

        it_should_behave_like "a strategy"

        it_should_find 'ingredients', [
          [
            "4 large egg yolks (save the whites for the pavlova)",
            "1/2 cup granulated sugar",
            "1/4 cup finely grated, loosely packed lemon zest (from about 5 to 6 medium lemons)",
            "1/3 cup freshly squeezed lemon juice (from about 3 to 4 lemons)",
            "1/8 teaspoon fine salt",
            "6 tablespoons unsalted butter (3/4 stick), cut into 6 pieces, at room temperature"
          ],
          [
            "4 large egg whites with no traces of yolk, at room temperature",
            "Pinch fine salt",
            "1 cup granulated sugar",
            "2 teaspoons cornstarch",
            "1 teaspoon distilled white vinegar",
            "1/2 teaspoon vanilla extract"
          ],
          [
            "1 cup cold heavy cream",
            "1 tablespoon granulated sugar",
            "1/2 teaspoon vanilla extract",
            "1 1/2 cups fresh berries, such as raspberries, blackberries, blueberries, or sliced strawberries"
          ]
        ]

        it 'should extract the ingredient list names correctly' do
          subject.ingredients.map(&:name).should == [
            'For the lemon curd:',
            'For the pavlova:',
            'To assemble:'
          ]
        end

        it_should_find 'images', [
          "http://search.chow.com/thumbnail/480/0/www.chow.com//assets/2011/04/29539_pavlova_lemon_curd_620.jpg",
          "http://www.chow.com/images/green_checkmark.png",
          "http://www.chow.com/assets/2011/04/lemoncurd_1.jpg",
          "http://www.chow.com/assets/2011/04/lemoncurd_2.jpg",
          "http://www.chow.com/assets/2011/04/lemoncurd_3.jpg",
          "http://www.chow.com/assets/2011/04/lemoncurd_4.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_1.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_2.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_3.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_4.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_5.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_6.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_7.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_8.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_9.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_10.jpg",
          "http://www.chow.com/assets/2011/04/pavlova_11.jpg"
        ]

      end

      context 'recipe with multiple sets of instuctions' do

        strategy_subject_for('http://www.chow.com/recipes/28966-apple-honey-upside-down-cakes')

        it_should_behave_like "a strategy"

        it_should_find 'steps', [
          [
            "Heat the oven to 325°F and arrange a rack in the middle. Coat 6 (6-ounce) ramekins with butter and evenly space them on a baking sheet. Divide almonds among the ramekins.",
            "Peel, core, and cut the apple into medium dice. Place in a medium, nonreactive bowl, add 1 tablespoon of the lemon juice, and toss to combine; set aside.",
            "Melt butter in a medium frying pan over medium-high heat until foaming. Add sugar, honey, and salt and stir to combine. Cook, swirling the pan occasionally, until mixture just starts to turn a light caramel color, about 5 minutes. Add the remaining 1 teaspoon lemon juice and stir to combine.",
            "Remove the pan from heat and carefully place about 2 tablespoons of the caramel in each ramekin. (Work quickly—the caramel will start to set after a few minutes.) Divide the apple pieces among the ramekins, leaving any juice in the bowl; set the ramekins aside."
          ],
          [
            "Place flour, orange zest, baking powder, cinnamon, and salt in a medium bowl and whisk to aerate and break up any lumps; set aside.",
            "Place butter in the bowl of a stand mixer fitted with a paddle attachment and beat on medium high until light in color and fluffy, about 2 minutes. Add sugar and vanilla and continue to beat until incorporated and fluffy, about 3 minutes more. Add eggs one at a time, letting the first incorporate before adding the second. Stop the mixer and scrape down the sides of the bowl and the paddle with a rubber spatula.",
            "Return the mixer to low speed, add the milk, and mix until just incorporated. Add the reserved flour mixture and mix until just incorporated, about 30 seconds; do not overmix. Evenly spoon the batter over the apples and smooth the tops. Bake until a cake tester comes out clean, about 35 minutes. Immediately run a knife around the perimeter of each cake. Using a dry kitchen towel to grasp the ramekins, invert the hot cakes onto serving plates. Serve with ice cream, if desired."
          ]
        ]

        it 'should extract out the steps names correctly' do
          subject.steps.map(&:name).should == [
            'For the caramel:',
            'For the cake:'
          ]
        end

        it_should_find 'images', [
          "http://search.chow.com/thumbnail/480/0/www.chow.com//assets/2010/10/28966_apple_honey_cakes_3_620.jpg",
          "http://www.chow.com/images/green_checkmark.png"
        ]

      end

      context 'a different layout with active time' do
        strategy_subject_for('http://www.chow.com/recipes/14271-olive-parsley-dip-with-crudites')
        it_should_behave_like 'a strategy'

        it 'returns the active time for cook time' do
          subject.cook_time.should == '20 mins'
        end
      end

      context 'with a beverage pairing' do
        strategy_subject_for('http://www.chow.com/recipes/10740-turkey-two-ways-roasted-breast-and-legs-confit')

        it_should_find 'steps', [
          [
            "Remove giblets and neck and freeze for some other use or discard. Rinse out cavity and thoroughly pat dry with paper towels. Trim most of excess fat and skin from neck and cavity.",
            "Remove legs by cutting where thighs meet the body. Reserve legs for confit and remainder of turkey breast piece (breast and body) for brine."
          ],
          [
            "Place all brining ingredients except vegetable oil in a large stockpot over high heat and bring to a boil. Remove and cool to room temperature.",
            "When brine is cool, submerge turkey breast piece in brine. (Use a resealable plastic bag filled halfway with water or some other weight to keep it completely submerged.) Cover and refrigerate for 24 hours.",
            "To roast, heat oven to 350°F. Remove breast from brine and thoroughly dry with paper towels. Rub skin with vegetable oil and place breast on a heavy baking sheet or in a roasting pan. Roast in oven until breast reaches an internal temperature of 150°F on an instant-read thermometer. Remove from oven and allow to rest for at least 10 minutes before carving. If not using foie gras in mushroom sauce, reserve 1/4 cup pan drippings."
          ],
          [
            "Place turkey legs on a large platter and heavily salt both sides of each leg. Sprinkle garlic, bay leaves, thyme, and peppercorns over top. Cover with plastic wrap and let rest 12 hours or overnight.",
            "Heat oven to 325°F. Remove salt from legs. Place legs, skin side down, with confit flavoring ingredients (except salt) in a Dutch oven or a large heavy-bottomed pot with a tightfitting lid and cover with duck fat and vegetable oil.",
            "Place over medium heat and bring to a simmer, making sure legs don’t stick. Cover, turn off heat, and place in oven. Cook until meat is very tender, about 2 hours.",
            "Remove casserole from oven and cool on a rack. If serving immediately, brown legs as described in next step; if not, place cooled casserole in the refrigerator until ready.",
            "To brown legs, heat oven to 350°F. Remove legs from casserole. Place a large nonstick frying pan on the stove over high heat. Carefully set legs skin side down in the pan and cook until skin is brown, about 2 minutes. Place in oven and cook until heated through, about 12 minutes."
          ],
          [
            "In a medium frying pan on medium-high heat, place duck fat or butter and sauté mushrooms in batches; season to taste. Reserve cooked mushrooms in a bowl. If using foie gras, quickly sauté it in the same pan used for the mushrooms (without any fat) on high heat and cook just until browned. Place on paper towels and reserve.",
            "Add shallots and cook on low heat for 3 minutes, then add stock. If not using foie gras, add 1/4 cup reserved pan drippings from turkey.",
            "When ready to serve, bring shallot mixture to a simmer, and add mushrooms, foie gras, and parsley. Mix well and serve immediately."
          ],
        ]
      end

    end

  end

end