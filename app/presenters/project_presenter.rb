class ProjectPresenter
	attr_reader :id, :name, :description, :location, :other_technologies, :owner,
				:current_user_owns, :current_user_interested, :interested_users,
				:rails, :ios, :android, :python, :java, :scala, :javascript

	def initialize(project, current_user = nil)
		@id = project.id
		@name = project.name
		@description = project.description
		@location = project.location
		@rails = project.rails
		@ios = project.ios
		@android = project.android
		@python = project.python
		@java = project.java
		@scala = project.scala
		@javascript = project.javascript
		@other_technologies = project.other_technologies
		@owner = UserPresenter.new(project.owner) if project.owner.present?
		if project.interested_users.present?
			@interested_users = project.interested_users.map do |user|
				UserPresenter.new(user).display_name
			end
		else
			@interested_users = ["no one yet"]
		end
		
		if current_user.present?
			@current_user_owns = project.owner == current_user
			@current_user_interested = project.interested_users.include? current_user
		end
	end
end