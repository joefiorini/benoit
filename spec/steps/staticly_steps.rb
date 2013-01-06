module StaticlySteps

  step "I see the current Staticly version" do
    require_relative "../../lib/staticly/version"
    assert_partial_output(Staticly::VERSION, all_output)
  end

end
