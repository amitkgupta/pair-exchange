class Project < ActiveRecord::Base
  OFFICES = ['SF', 'NY', 'Boulder', 'Denver', 'Santa Monica', 'Boston', 'London']

  attr_accessible :name, :owner, :description, :office, :other_technologies,
  					:rails, :ios, :android, :python, :java, :scala, :javascript
  
  belongs_to :owner, inverse_of: :projects, class_name: "User", foreign_key: "user_id"
  validates_presence_of :owner

  has_and_belongs_to_many :interested_users, class_name: "User"
end
