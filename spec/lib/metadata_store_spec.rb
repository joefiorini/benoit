require "json"
require "spec_helper"
require "spec_helpers/file_helpers"
require "staticly/page_metadata/store"
require "staticly/page_metadata/container"
require "staticly/page_metadata/parser"

class InputWrapper < Struct.new(:path, :read)
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

describe Staticly::PageMetadata::Store do
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

  let(:store) { described_class.current }

  describe "the metadata hash" do

    subject { write_page; store.import_from_page(input) }

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

    subject { write_page; store.import_from_page(input) }


    it "returns an empty hash" do
      expect(subject).to be_empty
    end

  end

  describe "memoizing" do

    subject { write_page; store.import_from_page(input) }

    it "keeps it from parsing again" do
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = store.import_from_page(new_input)
      expect(new_metadata).to eq(subject)
    end

    it "always returns the same hash" do
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = store.import_from_page(new_input)
      expect(new_metadata.object_id).to eq(subject.object_id)
    end

  end

  describe "expiring the entire collection" do


    subject { write_page; store.import_from_page(input) }

    it "clears memoized keys, allowing new keys to be written" do
      subject
      store.expire!
      write_new_page
      new_input = InputWrapper.new("tmp/index.html", new_content)
      new_metadata = store.import_from_page(new_input)
      expect(new_metadata).to have_metadata("key1").with_value("blah1")
      expect(new_metadata).to have_metadata("key2").with_value("blah2")
    end

  end

end

