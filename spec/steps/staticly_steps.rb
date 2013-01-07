module StaticlySteps

  step "I see the current Staticly version" do
    require_relative "../../lib/staticly/version"
    assert_partial_output(Staticly::VERSION, all_output)
  end

  step "a site named :site" do |site|
    create_dir site
    step 'I cd to "%s"' % site
    step 'an empty file named "index.html"'
  end

end
