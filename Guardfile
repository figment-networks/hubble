guard :rspec, cmd: 'bundle exec spring rspec' do
  watch(%r{^spec/(.+)_spec\.rb$})
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
