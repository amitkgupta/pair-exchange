class RemoveFinishedFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :finished
  end
end
