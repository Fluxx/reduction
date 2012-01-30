# encoding: UTF-8

require 'spec_helper'

module Reduction
  class Strategy

    describe MarthaStewart do
      use_vcr_cassette 'martha_stewart', tag: :base64_response_body

      describe 'for_url?' do

        it 'returns true for any martha stewart URL' do
          described_class.for_url?('http://www.marthastewart.com/').should be_true
        end

        it 'returns false for any other URL' do
          described_class.for_url?('http://ms.com').should be_false
        end

      end

      context 'normal recipe page' do
        strategy_subject_for('http://www.marthastewart.com/336507/brown-sugar-barbecue-chicken-drumettes?czone=food/dinner-tonight-center/dinner-tonight-main-courses&center=276948&gallery=275660&slide=284273')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'title', 'Brown-Sugar Barbecue Chicken Drumettes'
        
        it_should_find 'yields', 'Serves 8'
        
        it_should_find 'ingredients', [
          [
            "2 cups ketchup",
            "1 cup packed light-brown sugar",
            "2 tablespoons Worcestershire sauce",
            "2 tablespoons cider vinegar",
            "Coarse salt and ground pepper",
            "6 pounds chicken drumettes, patted dry"
          ]
        ]
        
        it_should_find 'steps', [
          [
            "In a medium bowl, whisk together ketchup, sugar, Worcestershire, and vinegar; season with salt and pepper. Set aside 1 cup sauce for tossing raw chicken; use rest for baked chicken.",
            "Preheat oven to 450 degrees, with racks in upper and lower thirds; line two rimmed baking sheets with aluminum foil.",
            "Divide drumettes between baking sheets, and toss with reserved 1 cup sauce.",
            "Bake chicken until opaque throughout, 30 to 35 minutes, rotating sheets and tossing chicken halfway through. Toss baked drumettes with 1/2 cup sauce, and serve with remaining sauce on the side."
          ]
        ]

        it_should_find 'prep_time', '10 minutes'
        it_should_find 'total_time', '45 minutes'
        it_should_find 'cook_time', nil
        
        it_should_find 'images', [
          "http://www.marthastewart.com/sites/files/marthastewart.com/imagecache/img_l/ecl/images/content/pub/everyday_food/2008Q2/med103841_0608_drumettes_vert.jpg"
        ]

        it_should_find 'notes', 'Chicken drumettes are actually part of the chicken wing -- just the right size for kids to nibble on. To store, refrigerate, up to 2 weeks.'

      end

      context 'with no notes' do
        strategy_subject_for('http://www.marthastewart.com/341314/chicken-parmigiana')

        it_should_behave_like "a strategy", :blessed

        it_should_find 'notes', nil
      end

      context 'without prep or cook time' do
        strategy_subject_for('http://www.marthastewart.com/355559/devils-food-cupcakes')

        it_should_behave_like 'a strategy', :blessed
      end

    end

  end

end