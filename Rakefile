namespace :bundle do
  task :sandbox do
    `bundle install --standalone=release --binstubs=.bundle/bin`
  end

  task :development do
    exec "bundle install --gemfile spec/Gemfile --binstubs=../.bundle/bin"
  end

  task :install => [:sandbox, :development]
end
