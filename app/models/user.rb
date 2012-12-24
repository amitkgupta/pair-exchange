class User < ActiveRecord::Base
	attr_accessible :email, :google_id
	validates_uniqueness_of :google_id
  	validates_presence_of :google_id
  	validates_presence_of :email

  	has_many :projects, inverse_of: :owner
  	
  	has_and_belongs_to_many :interests, class_name: "Project"
end
