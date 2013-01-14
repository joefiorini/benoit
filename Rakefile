task :features do
  exec "rspec -O .rspec-turnip"
end

task :spec do
  exec "rspec spec"
end

task default: [:features, :spec]
