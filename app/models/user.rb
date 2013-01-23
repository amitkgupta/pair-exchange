class User < ActiveRecord::Base
  attr_accessible :email, :google_id, :profile_image_url, :display_name
  validates_uniqueness_of :google_id
  validates_presence_of :google_id
  validates_presence_of :email

  has_many :projects, inverse_of: :owner

  has_and_belongs_to_many :interests, class_name: "Project"

  def self.admin_emails;
    ADMIN_EMAILS;
  end

  def self.create_or_update_from_google_data(google_api_interface)
    google_id = google_api_interface.current_user_google_id
    attributes = {
        email: google_api_interface.current_user_email,
        profile_image_url: google_api_interface.image_url_for_user(google_id),
        display_name: google_api_interface.display_name_for_user(google_id)
    }
    user = User.find_or_initialize_by_google_id(google_id)
    user.update_attributes(attributes)
  end

  def is_admin
    User.admin_emails.include? email
  end

end
