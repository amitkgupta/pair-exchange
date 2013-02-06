class Schedule
  def self.create(project, event)
    project.events << event
  end
end
