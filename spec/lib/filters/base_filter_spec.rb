require 'spec_helper'
require 'rake-pipeline'
require 'benoit/filters/base_filter'
require 'benoit/page'

describe Benoit::Filters::BaseFilter do
  MemoryFileWrapper ||= Rake::Pipeline::SpecHelpers::MemoryFileWrapper
  MemoryManifest ||= Rake::Pipeline::SpecHelpers::MemoryManifest

  let(:basic_filter) do
    Class.new(described_class)
  end

  let(:html_input) { "<html><head></head><body><h1>TESTING</h1></body></html>" }

  def input_file(name, content)
    MemoryFileWrapper.new("/path/to/input", name, "UTF-8", Set.new([]), content)
  end

  def output_file(name)
    MemoryFileWrapper.new("/path/to/output", name, "UTF-8", Set.new([]))
  end

  def setup_filter(filter, input_filename='index.html')
    filter.file_wrapper_class = MemoryFileWrapper
    filter.manifest = MemoryManifest.new
    filter.last_manifest = MemoryManifest.new
    filter.input_files = [input_file(input_filename, html_input)]
    filter.output_root= "/path/to/output"
    filter.rake_application = Rake::Application.new
    filter.current_site = {}
    filter
  end

  def setup_final_outputs(filter)
    filter.input_files.each_with_index do |input,i|
      output = filter.output_files[i]
      filter.current_site.merge!(input.path => { "content" => input.read })
      filter.current_site.merge!(output.path => { "content" => input.read })
    end
  end

  it "generates output directly from the input" do
    filter = setup_filter basic_filter.new

    expect(filter.output_files).to eq([output_file("index.html")])

    setup_final_outputs(filter)

    tasks = filter.generate_rake_tasks
    tasks.each(&:invoke)

    file = MemoryFileWrapper.files["/path/to/output/index.html"]
    expect(file.body).to eq(html_input)
  end

  describe "building output" do

    let(:builder_filter) do
      Class.new(described_class) do
        build_output do
          "blah"
        end
      end
    end

    let(:page_filter) do
      Class.new(described_class) do
        build_output do |page|
          page["content"]
        end
      end
    end

    let(:path_writer) do
      Class.new(described_class) do
        build_output do |page,input|
          input.path
        end
      end
    end

    it "gets output from calling builder" do
      filter = setup_filter builder_filter.new

      setup_final_outputs(filter)

      tasks = filter.generate_rake_tasks
      tasks.each(&:invoke)

      file = MemoryFileWrapper.files["/path/to/output/index.html"]
      expect(file.body).to eq("blah")
    end

    it "passes page object to builder" do
      filter = setup_filter page_filter.new

      setup_final_outputs(filter)

      page = filter.current_site[filter.output_files.first.path]

      tasks = filter.generate_rake_tasks
      tasks.each(&:invoke)

      file = MemoryFileWrapper.files["/path/to/output/index.html"]
      expect(file.body).to eq(page["content"])
    end

    it "passes input to builder when needed" do
      filter = setup_filter path_writer.new
      input = filter.input_files.first

      setup_final_outputs(filter)

      tasks = filter.generate_rake_tasks
      tasks.each(&:invoke)

      file = MemoryFileWrapper.files["/path/to/output/index.html"]
      expect(file.body).to eq(input.path)
    end

  end

  describe "generating output filename" do

    let(:output_name) do
      Class.new(described_class) do
        output_name do
          "blah.diddy"
        end
      end
    end

    it "gets output filename from calling generator" do
      filter = setup_filter output_name.new

      expect(filter.output_files).to eq([output_file("blah.diddy")])
    end
  end

end
