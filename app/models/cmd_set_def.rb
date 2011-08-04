class CmdSetDef < ActiveRecord::Base
  belongs_to :app
  has_many :cmd_sets

  # cmd set def 定义了一个命令包，对于指定的一个cmd_set_id，可以为之创建命令包所对应的一组执行命令
  def create_cmd_set user
    cmd_set = CmdSet.create :cmd_set_def => self, :operator => user, :name => name, :app => app
    build_commands cmd_set.id
  end

  def cmd_defs
    expression.split(',').inject([]) { |result, item|
      pair = item.squish.split('|')
      cmd_def = CmdDef.find(pair[0].to_i) rescue nil
      if cmd_def
        if block_given?
          yield cmd_def, (pair[1]=="true")
        end
        result << "#{item}-#{cmd_def.name}"
      else
        result
      end
    }
  end

  # 根据 cmd set id 生成 command 记录（同时command会自动生成 operation 记录)
  def build_commands cmd_set_id
    cmd_defs do |cmd_def, next_when_fail|
      if cmd_def
        Command.create(
            :cmd_def => cmd_def,
            :cmd_set_id => cmd_set_id,
            :next_when_fail => next_when_fail
        ).build_operations!
      end
    end
  end

end
