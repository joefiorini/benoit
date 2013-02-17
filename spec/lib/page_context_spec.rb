require 'spec_helper'
require 'staticly/page_context'

describe Staticly::PageContext do

  let(:metadata) { { "blah" => "diddy" } }
  subject { described_class.new(metadata) }

  describe "page metadata" do
    it "is accessible via []" do
      expect(subject["blah"]).to eq("diddy")
    end
    it "allows changing attributes via []" do
      subject["blah"] = "doo"
      expect(subject["blah"]).to eq("doo")
    end
  end

end
