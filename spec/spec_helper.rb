require 'reduction'
require 'rspec'
require 'ruby-debug'
require 'open-uri'

Dir['./spec/support/**/*.rb'].each { |f| require f }

module StrategyMacros
  def strategy_subject_for(url)
    subject { described_class.new(get_page(url), url) }
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  config.debug = true
  config.extend VCR::RSpec::Macros

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.alias_it_should_behave_like_to :it_should_find, "it should find a"
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.extend StrategyMacros
end