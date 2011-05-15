# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe Gourmet do

      subject { described_class.new(fixture(:gourmet)) }

      it_should_behave_like "a strategy"

      describe 'for_url?' do

        it 'returns true for any www.gourmet.com URL' do
          described_class.for_url?('http://www.gourmet.com').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://www.chowfoods.com').should be_false
        end

      end

      it_should_find 'title', 'Peppercorn-Roasted Pork with Vermouth Pan Sauce'

      it 'does not include gourmet.com in the title' do
        subject.title.should_not =~ /gourmet.com/i
      end

      it_should_find 'ingredients', [
        "6 tablespoons pink peppercorns, divided",
        "2 tablespoons black peppercorns",
        "1 1/2 tablespoons fennel seeds",
        "7 garlic cloves, minced",
        "3 tablespoons vegetable oil",
        "1 (5-lb) boneless pork shoulder roast (butt end)",
        "1/2 cup dry vermouth",
        "2 cups reduced-sodium chicken broth",
        "1 tablespoon unsalted butter, softened",
        "1 tablespoon all-purpose flour"
      ]

      it_should_find 'steps', [
        "Grind 1/4 cup pink peppercorns with black peppercorns and fennel seeds in grinder, then stir together with garlic, oil, and 1 Tbsp salt.",
        "Pat pork dry and use a paring knife to make about 16 (1-inch-deep) slits all over roast. Stuff slits with all but 1 Tbsp garlic-peppercorn paste, then rub remaining Tbsp all over roast. Put in a small (13- by 9-inch) flameproof roasting pan and marinate, chilled, 8 to 24 hours.",
        "Let pork stand at room temperature 1 hour. Preheat oven to 350°F with rack in middle.",
        "Roast pork, fat side up, until an instant-read thermometer inserted into center of meat registers 150°F, 1 1/2 to 2 hours. Transfer pork to a cutting board and let rest 30 minutes.",
        "Meanwhile, pour off all but about 1 Tbsp fat from roasting pan. Add vermouth to pan and boil, scraping up brown bits, 2 minutes. Stir in broth, any meat juices from cutting board, and remaining 2 Tbsp pink peppercorns and boil until reduced to about 11/2 cups, about 5 minutes.",
        "Knead together butter and flour, then whisk into sauce and boil, whisking constantly, until just slightly thickened, about 2 minutes.",
        "Serve pork with sauce."
      ]

      it_should_find 'yields', 'Serves 8'

      # it_should_find 'prep_time', ''
      #
      # it_should_find 'cook_time', ''
      #
      # it_should_find 'total_time', ''


    end

  end

end