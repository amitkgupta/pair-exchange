class Interest
	def self.create(project, user)
		project.interested_users << user
	end
	
	def self.destroy(project, user)
		project.interested_users.delete(user)
	end
end
