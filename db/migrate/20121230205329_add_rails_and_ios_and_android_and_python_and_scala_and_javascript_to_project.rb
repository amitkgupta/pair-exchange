class AddRailsAndIosAndAndroidAndPythonAndScalaAndJavascriptToProject < ActiveRecord::Migration
  def change
    add_column :projects, :rails, :boolean
    add_column :projects, :ios, :boolean
    add_column :projects, :android, :boolean
    add_column :projects, :python, :boolean
    add_column :projects, :scala, :boolean
    add_column :projects, :javascript, :boolean
  end
end
