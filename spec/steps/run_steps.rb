module RunSteps
  extend ::Turnip::DSL

  step "I run :cmd" do |cmd|
    run_simple(unescape(cmd), false)
  end

  step "a directory named :directory should exist" do |directory|
    check_directory_presence([directory], true)
  end

  step "an empty file named :file_name" do |file_name|
    write_file(file_name, "")
  end

  step "I cd to :directory" do |directory|
    cd directory
  end

  placeholder :cmd do
    match /`([^`]*)`/ do |cmd|
      cmd
    end
  end

end
