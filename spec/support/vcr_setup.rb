require 'vcr'
require 'base64'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :fakeweb
  
  c.default_cassette_options = { 
    :record => :new_episodes,
    :re_record_interval => 60*60*12, # Record every 12 hours
    :serialize_with => :syck
  }

  # Handles serialization errors with pages that have invalid UTF-8 characters
  c.before_record(:base64_response_body) do |interaction|
    interaction.response.body = YAML.dump(
      :encoding => interaction.response.body.encoding.name,
      :content  => Base64.encode64(interaction.response.body)
    )
  end

  c.before_playback(:base64_response_body) do |interaction|
    response_body_hash = YAML.load(interaction.response.body)
    string = Base64.decode64(response_body_hash[:content])
    string.force_encoding(response_body_hash[:encoding])
    interaction.response.body = string
  end
end