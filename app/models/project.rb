class Project < ActiveRecord::Base
  attr_accessible :name, :owner, :description, :office, :technology, :finished
  
  belongs_to :owner, inverse_of: :projects, class_name: "User", foreign_key: "user_id"
  validates_presence_of :owner

  has_and_belongs_to_many :interested_users, class_name: "User"
end