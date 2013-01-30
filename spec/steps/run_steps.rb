module RunSteps
  extend ::Turnip::DSL

  step "I run :cmd" do |cmd|
    run_simple(unescape(cmd), false)
  end

  step "I successfully run :cmd" do |cmd|
    run_simple(unescape(cmd))
  end

  step "a directory named :directory should exist" do |directory|
    if directory =~ /^~/
      directory = File.expand_path(directory)
    end
    check_directory_presence([directory], true)
  end

  step "an empty file named :file_name" do |file_name|
    write_file(file_name, "")
  end

  step "a file named :file_name with content:" do |file_name, content|
    write_file(file_name, content)
  end

  step "the file :file_name should contain:" do |file_name, partial_content|
    check_file_content(file_name, partial_content, true)
  end

  step "the file :file_name should match :pattern" do |file_name, pattern|
    check_file_content(file_name, /#{pattern}/, true)
  end

  step "I cd to :directory" do |directory|
    cd directory
  end

  step "a :size byte file named :file_name should exist" do |file_size, file_name|
    check_file_size([[file_name, file_size.to_i]])
  end

  step "a file named :file_name should exist" do |file_name|
    check_file_presence([file_name], true)
  end

  step "a file named :file_name should not exist" do |file_name|
    check_file_presence([file_name], false)
  end

  placeholder :cmd do
    match /`([^`]*)`/ do |cmd|
      cmd
    end
  end

  placeholder :pattern do
    match /\/([^\/]*)\/$/ do |pattern|
      pattern
    end
  end

end
