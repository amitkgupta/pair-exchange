class Event < ActiveRecord::Base
  attr_accessible :date, :location, :time
  has_and_belongs_to_many :projects
  
  def self.create_from_form_details(form_details)
  	create!(
  	  location: form_details[:location],
  	  date: DateTime.strptime(form_details[:date], '%m/%d/%Y').to_date,
  	  time: form_details[:time]
  	)
  end
  
  def self.for_location(location)
	where location: location
  end
end
