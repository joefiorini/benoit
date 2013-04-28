require 'yaml'
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

  def delete_page(page)
    @pages = @pages.reject { |p| p.name == page.name }
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
    num = 1_000_000 + Random.rand(10_000_000 - 1_000_000)
    @name = "page_#{num}#{extname}"
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

module BenoitSteps
  extend Turnip::DSL

  def create_file_for_page(page, include_metadata=true)
    content = if include_metadata
      page.full_content
    else
      page.content
    end
    step "a file named \"#{page.name}\" with content:", content
  end

  def delete_file_for_page(page)
    step 'I remove the file "%s"' % page.name
  end

  step "I see the current Benoit version" do
    require_relative "../../lib/benoit/version"
    assert_partial_output(Benoit::VERSION, all_output)
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

  step "a cache directory should exist for that site" do
    path = File.expand_path(File.join("~", ".benoit", "tmpcache", @site.name))
    step 'a directory named "%s" should exist' % path
  end

  step ":file_name should not exist in the output site" do |file_name|
    file_name = File.join("_build", file_name)
    step 'a file named "%s" should not exist' % file_name
  end

  step "I build the site" do
    step "I successfully run `benoit build`"
  end

  step "I build the site with the flag :flag" do |flag|
    step "I successfully run `benoit build #{flag}`"
  end

  step ":n files containing metadata:" do |n, yaml_snippet|
    n.to_i.times do |i|
      yaml = yaml_snippet + "\npage_num: #{i}"
      step 'a file with an extension of ".html" containing metadata:', yaml
      step 'that file has content:', i.to_s
    end
  end

  step "a file" do
    step 'a file with an extension of ".html"'
  end

  step "a file with an extension of :extname" do |extname|
    @page = Page.new
    @page.generate_name(extname)
    @site.add_page @page
    create_file_for_page @page
  end

  step "a file containing metadata:" do |yaml_snippet|
    step 'a file with an extension of ".html" containing metadata:', yaml_snippet
  end

  step "a file named :file_name containing metadata:" do |file_name,yaml_snippet|
    @page = Page.new(file_name)
    @site.add_page @page
    @page.add_metadata yaml_snippet
    create_file_for_page @page
  end

  step "a file with an extension of :extname containing metadata:" do |extname, yaml_snippet|
    @page = Page.new
    @page.generate_name(extname)
    @site.add_page @page
    @page.add_metadata yaml_snippet
    create_file_for_page @page
  end

  step "a file with an extension of :extname with content:" do |extname, content|
    @page = Page.new
    @page.generate_name(extname)
    @site.add_page @page
    @page.content = content
    create_file_for_page @page, false
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

  step "I delete the file" do
    @site.delete_page @page
    delete_file_for_page @page
  end

  step "the site has a file that is an image" do
    @image_path = "spec/support/files/img.png"
    img_content = File.read(@image_path)
    write_file("img.png", img_content)
  end

  step "the file :named should not exist in the output site" do |filename|
    path = File.join("_build", filename)
    step 'a file named "%s" should not exist' % path
  end

  step "that file should not exist in the output site" do
    path = File.join("_build", @page.name)
    step 'a file named "%s" should not exist' % path
  end

  step "that file should exist in the output site" do
    path = File.join("_build", @page.name)
    step 'a file named "%s" should exist' % path
  end

  step "the image should exist in the output site" do
    step 'a file named "%s" should exist' % ["_build/img.png"]
  end

end
