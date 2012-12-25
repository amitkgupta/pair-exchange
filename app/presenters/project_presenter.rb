class ProjectPresenter
	attr_reader :name, :description, :office, :technology, :owner

	def initialize(project)
		@name = project.name
		@description = project.description
		@office = project.office
		@technology = project.technology
		@owner = UserPresenter.new(project.owner) if project.owner.present?
	end
end