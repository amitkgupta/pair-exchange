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
  
  describe ".create_from_form_details" do
    it "creates an event from form details" do
      event = described_class.create_from_form_details(location: "NY", date: "12/31/1012")
      
      event.should be_persisted
      event.location.should == "NY"
      event.date.should == Date.new(1012, 12, 31)
    end
  end
end