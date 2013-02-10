class RemoveJavaAndScalaAndPythonFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :java
    remove_column :projects, :scala
    remove_column :projects, :python
  end

  def down
    add_column :projects, :python, :boolean
    add_column :projects, :scala, :boolean
    add_column :projects, :java, :boolean
  end
end
