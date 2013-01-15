require "json"
require "spec_helper"
require "page_metadata/importer"
require "page_metadata/parser"

class InputWrapper < Struct.new(:path, :read)
end

module FileHelpers
  def write_file(path, content)
    File.open(input.path, "w+") do |f|
      f << input.read
      f.path
    end
  end
end

RSpec::Matchers.define :have_metadata do |expected|
  match do |actual|
    expect(actual).to have_key(expected)
    expect(actual.fetch(expected)).to eq(@value) if @value
  end
  chain :with_value do |actual|
    @value = actual
  end
end

RSpec::Matchers.define :contain_page do |expected|
  match do |actual|
    page_name = expected
    expect(actual).to have_page(page_name)
    value = actual[page_name]
    expect(value).to eq(@metadata) if @metadata
  end
  chain :with_metadata do |metadata|
    @metadata = metadata
  end
end

describe Staticly::PageMetadata::Importer do
  include FileHelpers

  let(:content) do
    <<-EOF.unindent
    ---
    title: blah
    attr1: val1
    attr2: val2
    ---

    THE CONTENT
    EOF
  end

  let(:new_content) do
    <<-EOF.unindent
    ---
    key1: blah1
    key2: blah2
    ---

    THE CONTENT
    EOF
  end

  let(:write_page) { write_file(input.path, input.read) }
  let(:write_new_page) { write_file(input.path, new_content) }

  let(:input) { InputWrapper.new("tmp/index.html", content) }

  describe "the metadata hash" do

    subject { write_page; described_class.import_from_page(input) }

    it "contains the original content" do
      expect(subject).to have_metadata("content").with_value("THE CONTENT\n")
    end

    it "contains additional attributes" do
      expect(subject).to have_metadata("title").with_value("blah")
      expect(subject).to have_metadata("attr1").with_value("val1")
      expect(subject).to have_metadata("attr2").with_value("val2")
    end

  end

  describe "without metadata" do

    let(:content) { "THE CONTENT" }

    subject { write_page; described_class.import_from_page(input) }


    it "returns an empty hash" do
      expect(subject).to be_empty
    end

  end

  describe "memoizing" do

    subject { write_page; described_class.import_from_page(input) }

    it "keeps it from parsing again" do
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = described_class.import_from_page(new_input)
      expect(new_metadata).to eq(subject)
    end

    it "always returns the same hash" do
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = described_class.import_from_page(new_input)
      expect(new_metadata.object_id).to eq(subject.object_id)
    end

  end

  describe "expiring the entire collection" do


    subject { write_page; described_class.import_from_page(input) }

    it "clears memoized keys, allowing new keys to be written" do
      subject
      described_class.expire!
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = described_class.import_from_page(new_input)
      expect(new_metadata).to have_metadata("key1").with_value("blah1")
      expect(new_metadata).to have_metadata("key2").with_value("blah2")
    end

  end

end

describe Staticly::PageMetadata::JsonConverter do

  let(:index_html_metadata) do
    { "title" => "blah", "attr1" => "val1" }
  end

  let(:about_html_metadata) do
    { "title" => "about", "attr2" => "val2" }
  end

  let(:existing_metadata) do
    {
      "__index_html_metadata" => index_html_metadata,
      "__about_html_metadata" => about_html_metadata
    }
  end

  let(:json) { existing_metadata.to_json }

  it "loads all metadata into cache" do
    described_class.import!(json)
    store = Staticly::PageMetadata::Importer
    expect(store).to contain_page("index.html").with_metadata(index_html_metadata)
    expect(store).to contain_page("about.html").with_metadata(about_html_metadata)
  end

  it "exports all metadata currently in the cache" do
    described_class.import!(json)
    new_json = described_class.export
    expect(new_json).to eq(json)
  end

end
