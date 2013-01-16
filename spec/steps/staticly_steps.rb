class TestSite
  include Aruba::Api
  attr_reader :name
  attr_reader :pages

  def initialize
    @pages = []
  end

  def add_page(page)
    @pages << page
  end

  def generate_name
    @name = "site_#{Time.now.to_i}"
  end
end

class Page
  attr_reader :metadata, :name
  attr_accessor :content

  def initialize(name=nil)
    @name = name
    @metadata = {}
  end

  def add_metadata(yaml)
    YAML.load(yaml).tap do |m|
      @metadata.merge! m
    end
  end

  def generate_name(extname)
    @name = "page_#{Time.now.to_i}#{extname}"
  end

  def frontmatter(hash)
    unless hash.empty?
      %{#{hash.to_yaml}
      ---}.gsub(/^\s+/, "")
    end.to_s
  end

  def full_content
    %{#{frontmatter(metadata)}

    #{@content}}.gsub(/^\s+/, "")
  end

end

module StaticlySteps
  extend Turnip::DSL

  def create_file_for_page(page)
    step "a file named \"#{page.name}\" with content:", page.full_content
  end

  step "I see the current Staticly version" do
    require_relative "../../lib/staticly/version"
    assert_partial_output(Staticly::VERSION, all_output)
  end

  step "a site" do
    @site = TestSite.new
    @site.generate_name
    step "a site named #{@site.name}"
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

  step "I build the site" do
    step "I run `staticly build`"
  end

  step "the output file should have content:" do |content|
    file_name = File.join("_build", @page.name)
    step 'the file "%s" should contain:' % file_name, content
  end

  step "a file with an extension of :extname containing metadata:" do |extname, yaml_snippet|
    @page = Page.new
    @page.generate_name(extname)
    @site.add_page @page
    @page.add_metadata yaml_snippet
    create_file_for_page @page
  end

  step "that file has content:" do |content|
    @page.content = content
    create_file_for_page @page
  end

  step "a layout named :name with content:" do |name, content|
    name = "_layouts/" + name + ".html" unless File.extname(name) == ".html"
    @layout = Page.new(name)
    @layout.content = content
    @site.add_page @layout
    create_file_for_page @layout
  end

end
