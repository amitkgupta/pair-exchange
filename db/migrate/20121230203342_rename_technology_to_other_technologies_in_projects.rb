class RenameTechnologyToOtherTechnologiesInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :technology, :other_technologies
  end
end
