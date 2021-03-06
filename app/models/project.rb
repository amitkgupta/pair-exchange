class Project < ActiveRecord::Base
  LOCATIONS = ['SF', 'NY', 'Boulder', 'Denver', 'Santa Monica', 'Boston', 'London']

  attr_accessible :name, :owner, :description, :location, :other_technologies,
  					:rails, :ios, :android, :javascript

  belongs_to :owner, inverse_of: :projects, class_name: "User", foreign_key: "user_id"
  validates_presence_of :owner

  has_and_belongs_to_many :interested_users, class_name: "User"   
  has_and_belongs_to_many :events
  
  def self.create_from_form_details_and_user(form_details, owner)
	new(form_details).tap do |project|
		project.owner = owner
		project.save!
	end
  end
  
  def update_schedule_from_form_details(form_details)
  	scheduled_event_ids = form_details.select { |key, _| /event-\d+/.match(key) }.values
  	self.events = scheduled_event_ids.map { |id| Event.find id }
  end
end
