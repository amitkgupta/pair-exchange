class RenameOfficeToLocationInProjects < ActiveRecord::Migration
  def up
    rename_column :projects, :office, :location
  end

  def down
    rename_column :projects, :location, :office
  end
end
