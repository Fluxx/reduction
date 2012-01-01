require 'spec_helper'

describe Reduction do

  describe '.strategies' do

  	it 'defers to Strategy.all' do
  		described_class::Strategy.should_receive(:all)
      described_class.strategies
  	end

  end

  describe 'supports?' do

  	it 'returns true if any of the strategies support the defined URL' do
  		described_class.strategies.first.stub(for_url?: true)
  		described_class.supports?('http://www.example.com').should be_true
  	end

  	it 'suport any arbitrary URL' do
  		described_class.supports?('http://www.google.com').should be_true
  	end

  	it 'returns false for missing or incorrectly formatted URLs' do
  		described_class.supports?(nil).should be_false
  		described_class.supports?(false).should be_false
  		described_class.supports?('junk').should be_false
  	end

  end

  describe '.reduce' do
    let(:url) { 'http://www.google.com' }
    let(:html) { 'html' }
    let(:supporting) { mock(:strategy) }

    before(:each) { described_class::Strategy.stub(for_url: supporting) }

    it 'returns an instance of the strategy for the URL' do
      supporting.should_receive(:new).with(html, url).and_return(:strat)
      described_class.reduce(html, url).should == :strat
    end

    context 'when no strategy exists' do
      before(:each) { described_class::Strategy.stub(for_url: nil) }

      it 'raises an unsupported URI exception' do
        expect {
          described_class.reduce(html, url)  
        }.to raise_error(described_class::UnsupportedURI)
      end
    end

  end

end