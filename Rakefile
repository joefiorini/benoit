task :features do
  exec "rspec -O .rspec-turnip spec/features"
end

task :spec do
  exec "rspec spec"
end

task default: [:features, :spec]
