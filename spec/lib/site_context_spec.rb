require 'spec_helper'
require 'benoit/page'
require 'benoit/site_context'
require 'benoit/utils/paginated_list'

include Benoit

describe SiteContext do

  subject { described_class.new(pages) }

  describe "looking up pages" do
    let(:output_page) { Page.new("_original_path" => output_path) }
    let(:pages) { [output_page] }
    let(:output_path) { "blah" }

    it "uses paths map to normalize input paths to output paths" do
      subject.paths_map = { "input" => output_path }
      expect(subject["input"]).to eq(output_page)
    end

  end

end

RSpec::Matchers.define :be_pointing_at_first_page do
  match do |expected|
    expected.peek == [pages.first]
  end
end

describe SiteContext::ContextObject do

  let(:type) { "post" }
  let(:page) { {"_type" => type} }
  let(:num_pages) { 2 }
  let(:site) { SiteContext.new(pages) }
  let(:context) { site.to_context }
  let(:pages) do
    (1..num_pages).map do |i|
      page.merge("page" => i)
    end
  end

  subject { context.posts }

  after do
    SiteContext.clear_paginated_collections!
  end

  it "returns posts from content collection via method call" do
    expect(subject).to eq(pages)
  end

  describe "returns other types of content" do
    let(:type) { "comic" }
    subject { context.comics }

    it { should eq(pages) }
  end

  describe "for non-existant collections" do
    subject { context.blah }
    it "returns an empty array" do
      expect(subject).to eq([])
    end
  end

  describe "pagination" do
    let(:num_pages) { 3 }
    subject { context.paginated_posts }

    before do
      SiteContext.paginate_collection("posts", 1)
      pages << {"posts_per_page" => 1}
    end

    it "collects resource names with per_page count" do
      expect(site.paginated_collections["posts"]).to eq([1])
    end

    it "returns the collection sliced by page" do
      collection = subject.each
      expect(collection.next.first).to eq(pages.first)
      expect(collection.next.first).to eq(pages[1])
      expect(collection.next.first).to eq(pages[2])
    end

    it "returns the existing list if already set" do
      list = context.paginated_collection("posts")
      expect(context.paginated_collection("posts")).to eq(list)
    end

    it "rewinds the list if it is at the end" do
      # Fast-forward list to end
      1.upto(num_pages) do
        subject.each{|p|}
      end
      new_list = context.paginated_posts
      expect{new_list.peek}.to_not raise_error(StopIteration)
      expect(new_list).to be_pointing_at_first_page
    end

  end

end
