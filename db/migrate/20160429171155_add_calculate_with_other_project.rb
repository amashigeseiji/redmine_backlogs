class AddCalculateWithOtherProject < ActiveRecord::Migration
  def up
    add_column :rb_project_settings, :calculate_with_other_project, :string, :default => "", :null => false
  end

  def down
    remove_column :rb_project_settings, :calculate_with_other_project
  end
end
