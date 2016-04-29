class AddCalculateSprintName < ActiveRecord::Migration
  def self.up
    add_column :rb_project_settings, :calculate_sprint_name, :string, :default => "", :null => false
  end

  def self.down
    remove_column :rb_project_settings, :calculate_sprint_name
  end
end
