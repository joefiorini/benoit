module OutputFileSteps
  extend Turnip::DSL

  step "the output file should have content:" do |content|
    step 'the output file "%s" should have content:' % @page.name, content
  end

  step "the output file should only have content:" do |content|
    step 'the output file "%s" should only have content:' % @page.name, content
  end

  step "the output file :file_name should only contain the :ordinal :num :type" do |file_name,ordinal,num,type|
    pages =
      case ordinal
      when "first"
        @site.pages[0, num.to_i]
      when "last"
        @site.pages[-1 * num.to_i, num.to_i]
      end
    content = pages.map(&:content).join("\n") + "\n"
    step 'the output file "%s" should only have content:' % file_name, content
  end

  step "the output file :file_name should exist" do |file_name|
    file_name = File.join("_build", file_name)
    step 'a file named "%s" should exist' % file_name
  end

  step "the output file :file_name should have content:" do |file_name, content|
    file_name = File.join("_build", file_name)
    step 'the file "%s" should contain:' % file_name, content
  end

  step "the output file :file_name should only have content:" do |file_name, content|
    file_name = File.join("_build", file_name)
    step 'the file "%s" should contain exactly:' % file_name, content
  end

  step "the output file :file_name should match :pattern" do |file_name, pattern|
    file_name = File.join("_build", file_name)
    step 'the file "%s" should match /%s/' % [file_name, pattern]
  end


end
