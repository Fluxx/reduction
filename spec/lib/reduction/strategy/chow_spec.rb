# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Chow do

      subject { described_class.new(fixture(:chow)) }

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
        "2 pints (4 cups) premium or homemade vanilla ice cream, softened until just spreadable but not melted",
        "2 pounds milk chocolate couverture or coarsely chopped milk chocolate"
      ]

      it_should_find 'steps', [
        "Line a 9-by-9-inch baking pan with plastic wrap, overlapping as needed to completely cover the bottom and sides and leaving at least a 5-inch overhang. (If possible, use a pan that does not have sloping sides.)",
        "Drop the ice cream in large dollops into the pan and spread to the edges with a rubber spatula.  Cover with the overhanging plastic wrap and press on the surface of the ice cream with the bottom of a measuring cup until it’s packed into a smooth, even layer.  Freeze until solid, at least 3 hours.",
        "Meanwhile, line 2 baking sheets with parchment or waxed paper. Tape each corner of the paper down and place the baking sheets in the freezer. ",
        "When the ice cream is solid, remove the pan and 1 baking sheet from the freezer. Grasping the plastic wrap, pull the ice cream slab out of the pan and place it on a cutting board. Remove and discard the plastic wrap. Slice the slab into 9 even squares.",
        "Using a flat spatula, transfer and evenly space the squares on the baking sheet.  Freeze until solid, at least 2 hours.",
        "Fill a large bowl with 2 inches of cold water, add 3 to 4 ice cubes, and set aside.",
        "Bring a medium saucepan filled with 1 to 2 inches of water to a simmer over high heat; once simmering, reduce the heat to low and maintain a bare simmer. Place 24 ounces of the chocolate in a large, dry, heatproof bowl. Set the bowl over the saucepan and stir with a rubber spatula until the chocolate is completely melted and has reached 118°F. (Make sure the chocolate does not come into contact with any water or exceed 120°F. If either happens, start over, as the chocolate is no longer usable.)",
        "Remove the bowl from the saucepan. Add the remaining 8 ounces of chocolate and stir constantly, scraping against the bottom of the bowl, until all of the chocolate has melted and the temperature has cooled to 80°F. To speed the cooling process, after all of the chocolate has melted you can place the bowl over the reserved cold-water bath.",
        "Return the bowl to the saucepan and stir until the chocolate reaches 86°F; immediately remove from heat. Do not remove the thermometer from the bowl; check the temperature periodically to make sure it stays between 85°F and 87°F. (The chocolate must remain in this temperature range or it will not set up properly.) Keep the saucepan over low heat and use it to reheat the chocolate as necessary.",
        "To test if the chocolate is properly tempered, spread a thin layer on parchment or waxed paper and place it in the refrigerator for 3 minutes to set. If the chocolate hardens smooth and without streaks, it is properly tempered. (If it is not properly tempered, let the melted chocolate harden and start the tempering process over again: Bring the chocolate up to 118°F, then down to 80°F, then up again to 86°F.)",
        "Have a fork and flat spatula ready. Remove the empty baking sheet and the baking sheet with the ice cream squares from the freezer. Working quickly, use the flat spatula to drop 1 ice cream square into the chocolate. Using the fork, flip the square, making sure the edges are covered in chocolate. Lift the square out of the chocolate with the fork and tap the fork several times on the edge of the bowl to even out the coating. Scrape the bottom of the fork against the edge of the bowl to remove any excess chocolate.  Place the coated square on the empty baking sheet. Repeat with the remaining squares and chocolate, tilting the bowl as needed to pool the chocolate in one area, and spacing the squares as close together as possible on the baking sheet without touching.  (If the ice cream squares start to melt, return them to the freezer until firm before continuing.)",
        "Freeze the dipped ice cream bars until the chocolate coating has hardened and the ice cream is solid, at least 2 hours. Wrap them individually in plastic wrap, then foil, and store in the freezer for up to 2 weeks."
      ]

      it_should_find 'yields', '9 (3-inch-square) bars'

      it_should_find 'prep_time', nil

      it_should_find 'cook_time', nil

      it_should_find 'total_time', '45 mins, plus at least 7 hrs freezing time'


    end

  end

end