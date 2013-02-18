require 'spec_helper'
require 'rake-pipeline'
require 'staticly/filters'
require 'staticly/page'
require 'staticly/compiler_error'

describe Staticly::Filters::SassFilter do
  MemoryFileWrapper ||= Rake::Pipeline::SpecHelpers::MemoryFileWrapper
  MemoryManifest ||= Rake::Pipeline::SpecHelpers::MemoryManifest
  FileWrapper ||= Rake::Pipeline::FileWrapper

  let(:scss_input_path) {
    File.expand_path("spec/support/files/input.scss")
  }

  let(:expected_output) {
    str =
    <<-EOS
    .test .nested {
      attribute: value; }
    EOS
    str.unindent
  }

  def input_file
    path = scss_input_path
    FileWrapper.new(File.dirname(path), File.basename(path), "UTF-8", Set.new([]))
  end

  def output_file(name)
    MemoryFileWrapper.new("/path/to/output", name, "UTF-8", Set.new([]))
  end

  def setup_filter(filter)
    filter.file_wrapper_class = MemoryFileWrapper
    filter.manifest = MemoryManifest.new
    filter.last_manifest = MemoryManifest.new
    filter.input_files = [input_file]
    filter.output_root= "/path/to/output"
    filter.rake_application = Rake::Application.new
    filter
  end

  it "generates the correct output" do
    filter = setup_filter described_class.new

    input_file = filter.input_files.first
    output_file = output_file("input.css")

    expect(filter.output_files).to eq([output_file])

    tasks = filter.generate_rake_tasks
    tasks.each(&:invoke)

    file = MemoryFileWrapper.files["/path/to/output/input.css"]
    expect(file.body).to eq(expected_output)
  end

  describe "files ending in .css.scss" do

    let(:scss_input_path) {
      File.expand_path("spec/support/files/input.css.scss")
    }

    it "do not end in .css.css" do
      filter = setup_filter described_class.new

      output_file = output_file("input.css")
      expect(filter.output_files).to eq([output_file])
    end

  end
end
