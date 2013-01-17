require "staticly/page_metadata/store"
require "staticly/page_metadata/json_converter"

RSpec::Matchers.define :contain_page do |expected|
  match do |actual|
    page_name = expected
    expect(actual).to have_page(page_name)
    value = actual[InputWrapper.new(page_name)]
    expect(value).to eq(@metadata) if @metadata
  end
  chain :with_metadata do |metadata|
    @metadata = metadata
  end
end

include Staticly::PageMetadata
describe Staticly::PageMetadata do

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

  describe JsonConverter do

    let(:json) { existing_metadata.to_json }

    it "loads all metadata into cache" do
      JsonConverter.import!(json)
      store = Staticly::PageMetadata::Store.current
      expect(store).to contain_page("index.html").with_metadata(index_html_metadata)
      expect(store).to contain_page("about.html").with_metadata(about_html_metadata)
    end

    it "exports all metadata currently in the cache" do
      JsonConverter.import!(json)
      new_json = JsonConverter.export
      expect(new_json).to eq(json)
    end

  end


  describe SiteContextConverter do

    it "exports a hash with site paths instead of metadata keys" do
      JsonConverter.import!(existing_metadata.to_json)
      exported = SiteContextConverter.export
      expect(exported.keys).to eq(["index.html", "about.html"])
    end
  end

end

