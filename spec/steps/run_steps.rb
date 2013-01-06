module RunSteps
  extend ::Turnip::DSL

  step "I run :cmd" do |cmd|
    run_simple(unescape(cmd), false)
  end

  placeholder :cmd do
    match /`([^`]*)`/ do |cmd|
      cmd
    end
  end

end
