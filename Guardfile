guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^core_ext/(.+)\.rb})     { |m| "spec/core_ext/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }
end