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

  step "the output file :file_name should contain:" do |file_name, content|
    assert_success true
    file_name = File.join("_build", file_name)
    step 'the file "%s" should contain:' % file_name, content
  end

end
