class CreateDirectives < ActiveRecord::Migration
  def self.up
    create_table :directives do |t|
      t.integer :cmd_set_id
      t.integer :machine_id
      t.integer :cmd_def_id
      t.boolean :next_when_fail
      t.string :state
      t.boolean :isok, :default => false
      t.text :response

      # 冗余字段
      t.integer :room_id
      t.string :room_name
      t.string :machine_host
      t.string :command_name

      # 时间戳
      t.timestamps
    end
    add_index :directives, ["machine_id"], :name => "index_directives_on_machine_id"
    add_index :directives, ["state"], :name => "index_directives_on_state"
  end

  def self.down
    change_table(:directives) do |t|
      t.remove_index :index_directives_on_machine_id
      t.remove_index :index_directives_on_status
    end
    drop_table :directives
  end
end
