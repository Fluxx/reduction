require 'spec_helper'

describe Reduction do

  describe '.strategies' do

  	it 'returns an array of strategies available' do
  		described_class.strategies.should =~ [
	  		Reduction::Strategy::AllRecipes,
        Reduction::Strategy::Chow,
        Reduction::Strategy::Epicurious,
        Reduction::Strategy::Food,
        Reduction::Strategy::FoodAndWine,
        Reduction::Strategy::FoodNetwork,
        Reduction::Strategy::Gourmet
     	]
  	end

  end

  describe 'supports?' do

  	it 'returns true if any of the strategies support the defined URL' do
  		Reduction::Strategy::Chow.stub(for_url?: true)
  		described_class.supports?('http://www.example.com').should be_true
  	end

  	it 'returns false if no URL matches' do
  		described_class.supports?('http://www.google.com').should be_false
  	end

  	it 'returns false for missing or incorrectly formatted URLs' do
  		described_class.supports?(nil).should be_false
  		described_class.supports?(false).should be_false
  		described_class.supports?('junk').should be_false
  	end

  end
end