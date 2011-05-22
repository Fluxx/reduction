require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  # Record every 2 days
  c.default_cassette_options = { :record => :new_episodes, :re_record_interval => 60*60*12 }
end