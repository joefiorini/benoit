require "spec_helper"
require "page_metadata/importer"
require "page_metadata/parser"

# import Metadata.Importer

# module Metadata
# where
# load_metadata_for_path
# => "_load_#{converted_path}_metadata"
# => "set_metadata_for_path"
# => "memoize_metadata"

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

describe Staticly::PageMetadata::Importer do
  include FileHelpers

  describe "the metadata hash" do

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

    let(:input) { InputWrapper.new("tmp/index.html", content) }

    let(:write_page) { write_file(input.path, input.read) }

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

    let(:input) { InputWrapper.new("tmp/index.html", content) }

    let(:write_page) { write_file(input.path, input.read) }

    subject { write_page; described_class.import_from_page(input) }


    it "returns an empty hash" do
      expect(subject).to be_empty
    end

  end

  describe "memoizing" do

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

    let(:input) { InputWrapper.new("tmp/index.html", content) }

    let(:write_page) { write_file(input.path, input.read) }
    let(:write_new_page) { write_file(input.path, new_content) }

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

    it "removes all memoized collections"

  end

  describe "expiring a single page" do

    it "removes the memoized collection for that page"
  end

end
