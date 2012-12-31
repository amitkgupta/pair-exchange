class AddJavaToProject < ActiveRecord::Migration
  def change
    add_column :projects, :java, :boolean
  end
end
