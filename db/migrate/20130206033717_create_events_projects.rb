class CreateEventsProjects < ActiveRecord::Migration
  def up
    create_table :events_projects, id: false do |t|
      t.integer :project_id
      t.integer :event_id
    end
  end

  def down
    drop_table :events_projects
  end
end
