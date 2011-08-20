class CmdSetDef < ActiveRecord::Base
  belongs_to :app
  has_many :cmd_sets

  # cmd set def 定义了一个命令包，对于指定的一个cmd_set_id，可以为之创建命令包所对应的一组执行命令
  def create_cmd_set user, choosedMachineIds
    cmd_set = cmd_sets.create :operator => user, :name => name, :app => app
    build_operations cmd_set.id, choosedMachineIds
  end

  # 根据 cmd set id 生成 command 记录（同时command会自动生成 operation 记录)
  # choosedMachineIds 要求必须是一个integer数组
  def build_operations cmd_set_id, choosedMachineIds
    if choosedMachineIds
      machines = app.machines.where(:id => choosedMachineIds[0..10]).select([:id, :host, :room_id])
    else
      machines = app.machines.select([:id, :host, :room_id])
    end
    room_map = Room.
        where(:id => machines.collect { |m| m.room_id }.uniq).
        inject({}) { |map, room| map.update(room.id => room.name) }

    cmd_defs do |cmd_def, next_when_fail|
      # 循环创建 operation 对象
      machines.collect { |m|
        command_name = cmd_def.name
        cmd_def_id = cmd_def.id
        m.operations.create(
            :cmd_def_id => cmd_def_id,
            :cmd_set_id => cmd_set_id,
            :room_id => m.room_id,
            :machine_host => m.host,
            :command_name => command_name,
            :room_name => room_map[m.room_id],
            :next_when_fail => next_when_fail
        )
      }
    end
  end

  def cmd_defs
    expression.split(',').collect { |item|
      pair = item.squish.split('|')
      cmd_def = CmdDef.find(pair[0].to_i) rescue nil
      if cmd_def and block_given?
        yield cmd_def, (pair[1]=="true")
      end
      cmd_def
    }
  end

end
