class ProjectPresenter
	attr_reader :id, :name, :description, :office, :technology, :owner,
				:current_user_owns, :current_user_interested

	def initialize(project, current_user = nil)
		@id = project.id
		@name = project.name
		@description = project.description
		@office = project.office
		@technology = project.technology
		@owner = UserPresenter.new(project.owner) if project.owner.present?
		
		if current_user.present?
			@current_user_owns = project.owner == current_user
			@current_user_interested = project.interested_users.include? current_user
		end
	end
end