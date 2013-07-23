require 'spec_helper'
require 'rake-pipeline'
require 'benoit/filters'
require 'benoit/page'

describe Benoit::Filters::MarkdownFilter do
  MemoryFileWrapper ||= Rake::Pipeline::SpecHelpers::MemoryFileWrapper
  MemoryManifest ||= Rake::Pipeline::SpecHelpers::MemoryManifest

  let(:markdown_input) {
    <<-EOS.unindent
    [some link](http://www.example.com)

    **strong**
    _em_
    EOS
  }

  let(:markdown_extends_input) {
    <<-EOS.unindent
    {% extends "_layout.html" %}

    [some link](http://www.example.com)
    EOS
  }

  let(:expected_output) {
    <<-EOS.unindent
    <p><a href="http://www.example.com">some link</a></p>

    <p><strong>strong</strong>
    <em>em</em></p>
    EOS
  }

  let(:expected_extends_output) {
    <<-EOS
{% extends "_layout.html" %}

<p><a href="http://www.example.com">some link</a></p>
EOS
  }

  def input_file(name, content)
    MemoryFileWrapper.new("/path/to/input", name, "UTF-8", content)
  end

  def output_file(name)
    MemoryFileWrapper.new("/path/to/output", name, "UTF-8")
  end

  def setup_filter(filter, input_filename='page.markdown', content=markdown_input)
    filter.file_wrapper_class = MemoryFileWrapper
    filter.manifest = MemoryManifest.new
    filter.last_manifest = MemoryManifest.new
    filter.input_files = [input_file(input_filename, content)]
    filter.output_root= "/path/to/output"
    filter.rake_application = Rake::Application.new
    filter
  end

  it "generates the correct output" do
    filter = setup_filter described_class.new

    input_file = filter.input_files.first
    output_file = output_file("page.html")

    expect(filter.output_files).to eq([output_file])

    tasks = filter.generate_rake_tasks
    tasks.each(&:invoke)

    file = MemoryFileWrapper.files["/path/to/output/page.html"]
    expect(file.body).to eq(expected_output)
  end

  it "keeps extends tag in place" do
    filter = setup_filter described_class.new, 'page.markdown', markdown_extends_input

    input_file = filter.input_files.first

    tasks = filter.generate_rake_tasks
    tasks.each(&:invoke)

    file = MemoryFileWrapper.files["/path/to/output/page.html"]
    expect(file.body).to eq(expected_extends_output)
  end
end
