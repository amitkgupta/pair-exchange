class Interest
	def self.create(project, user)
		project.interested_users << user
		user.save!
		project.save!
	end
end
