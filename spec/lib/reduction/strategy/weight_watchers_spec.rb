# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe WeightWatchers do
      use_vcr_cassette 'weight_watchers'

      describe 'for_url?' do

        it 'returns true for any food52.com URL' do
          described_class.for_url?('http://www.weightwatchers.com/').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://www.ww.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://www.weightwatchers.com/food/rcp/RecipePage.aspx?recipeid=139331')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'title', 'Thai Chicken Skewers'
        
        it_should_find 'yields', 'Serves 8'
        
        it_should_find 'ingredients', [
          [
            "13 1/2 fl oz  light coconut milk, about 1 3/4 cups",
            "2 Tbsp  cilantro, fresh, chopped, or to taste",
            "1 Tbsp  dark brown sugar",
            "1 1/2 tsp  thai curry paste",
            "1 tsp  ginger root, fresh, grated",
            "1 tsp  lime zest",
            "3/4 tsp  table salt",
            "2 spray(s)  cooking spray",
            "1 pound(s)  uncooked boneless skinless chicken breast(s), pounded thin, cut crosswise on the diagonal into 16 strips"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "In a medium bowl, whisk together coconut milk, cilantro, sugar, curry paste, ginger, lime zest and salt until blended; set 1 cup of coconut milk mixture aside for dipping sauce.",
            "Transfer remaining coconut milk mixture to a resealable plastic food storage bag (or shallow glass container with cover). Add chicken to bag (or container), seal and turn to coat; refrigerate at least 1 hour or up to 3 hours.",
            "Meanwhile, soak sixteen 18-inch wooden skewers in water for 20 to 30 minutes(to prevent scorching).",
            "Preheat broiler. Line a broiler pan rack with nonstick aluminum foil (or use a nonstick baking sheet coated with cooking spray).",
            "Remove chicken from marinade; discard marinade. Thread one piece of chicken onto each skewer and place on prepared pan; coat with cooking spray. Broil, turning once, until chicken is cooked through, about 5 to 6 minutes.",
            "Meanwhile, bring reserved sauce to a boil in a small saucepan. Reduce heat and simmer, stirring occasionally, until slightly thickened and reduced to 1/2 cup, about 5 minutes. Arrange skewers on serving platter. Spoon sauce into a bowl for dipping. Yields 2 skewers and about 1 tablespoon of sauce per serving."
          ]
        ]

        it_should_find 'prep_time', '15 min'
        it_should_find 'cook_time', '6 min'
        
        it_should_find 'images', ['http://aka.weightwatchers.com/images/1033/dynamic/foodandrecipes/2010/04/thaichickenskewers_036_n_lg.jpg']

        it_should_find 'notes', "Cook the chicken on an outdoor grill or grill pan for attractive grill marks."

      end

      context 'a recipe without notes' do
        strategy_subject_for('http://www.weightwatchers.com/food/rcp/RecipePage.aspx?recipeId=218411')

        it_should_behave_like "a strategy", :blessed
        it_should_find 'notes', nil
      end
        
    end

  end

end