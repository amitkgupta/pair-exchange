require 'spec_helper'

describe Event do
  describe "accessible attributes" do
    specify do
      described_class.accessible_attributes.to_a.reject{ |attr| attr.blank? }.should =~ [
          "date",
          "location",
      ]
    end
  end
end