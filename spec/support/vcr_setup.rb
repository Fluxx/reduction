require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :fakeweb
  
  c.default_cassette_options = { 
    :record => :new_episodes,
    :re_record_interval => 60*60*12, # Record every 12 hours
    :serialize_with => :syck
  }
end