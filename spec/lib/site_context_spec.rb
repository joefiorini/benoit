require 'spec_helper'
require 'staticly/site_context'
require 'staticly/utils/paginated_list'

include Staticly

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
    it "raises an error" do
      expect(->{subject}).to raise_error(NoMethodError)
    end
  end

  describe "pagination" do
    let(:num_pages) { 3 }
    it "returns a paginated list when posts_per_page specified" do
      SiteContext.paginate_collection("posts", 1)
      pages << {"posts_per_page" => 1}
      expect(subject).to be_a(Staticly::Utils::PaginatedList)
    end

  end

end
