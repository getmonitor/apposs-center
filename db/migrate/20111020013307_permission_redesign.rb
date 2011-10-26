class PermissionRedesign < ActiveRecord::Migration
  def self.up
    add_index :roles, :name
    change_table :stakeholders do |t|
      t.rename :app_id, :resource_id
      t.string :resource_type
    end
  end

  def self.down
    change_table :stakeholders do |t|
      t.remove :resource_type
      t.rename :resource_id, :app_id
    end
    remove_index :roles, :name
  end
end
