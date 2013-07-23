# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group 'acceptance-tests' do
  guard 'rspec', cli: '-O .rspec-turnip', turnip: true, spec_paths: ['spec/features'] do

    watch('spec/turnip_helper.rb')  { "spec/features" }

    watch(%r{^lib/(.+)\.rb$})     { "spec/features" }

    watch('Assetfile') { 'spec/features' }

    # Turnip features and steps
    watch(%r{^spec/features/(.+)\.feature$})
    watch(%r{^spec/support/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/features' }
  end
end

group 'unit-tests' do
  guard 'rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }

  end
end
