class DropInterestsTable < ActiveRecord::Migration
  def up
    drop_table :interests
  end

  def down
    create_table :interests do |t|
      t.string :user
      t.references :project
      t.timestamps
    end
  end
end
