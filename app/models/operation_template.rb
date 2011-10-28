# coding: utf-8

# 操作模板，所有的运维操作都基于一个模型来执行，大部分原子指令也是在 gen_operation 的时候生成的
class OperationTemplate < ActiveRecord::Base
  belongs_to :app
  has_many :operations
  
  attr_accessor :source_ids

  validates_length_of :source_ids,:minimum => 1,:message => "至少需要选择一个"
  
  validates_uniqueness_of :name, :scope => [:app_id]
  
  validates_presence_of :name

  before_save do
    self.expression = self.source_ids.join "," if self.source_ids
  end

  # operation_template 创建了一个操作，对于指定的一个operation_id，可以为之创建操作所对应的一组执行指令
  def gen_operation user, choosed_machine_ids,previous_id=nil, is_hold=nil
    state = case is_hold
              when true
                'hold'
              when false
                'wait'
              else
                'init'
            end
    operation = operations.create(
        :operator => user, :name => name, :app => app,:previous_id => previous_id,:state => state
    )
    build_directives operation.id, choosed_machine_ids, state != 'init'
    operation
  end

  # 根据 cmd set id 生成 command 记录（同时command会自动生成 directive 记录)
  # choosedMachineIds 要求必须是一个integer数组
  def build_directives operation_id, choosed_machine_ids, is_hold
    if choosed_machine_ids
      machines = app.machines.where(:id => choosed_machine_ids[0..10]).select([:id, :host, :room_id])
    else
      machines = app.machines.select([:id, :host, :room_id])
    end
    room_map = Room.
        where(:id => machines.collect { |m| m.room_id }.uniq).
        inject({}) { |map, room| map.update(room.id => room.name) }

    properties = Property.global.pairs
    properties.update( app.properties.pairs )
    directive_templates do |directive_template, next_when_fail|
      # 循环创建 directive 对象
      machines.collect { |m|
        command_name = directive_template.name
        directive_template_id = directive_template.id
        properties.update(m.env.properties.pairs) if m.env

        m.directives.create(
            :directive_template_id => directive_template_id,
            :operation_id => operation_id,
            :room_id => m.room_id,
            :machine_host => m.host,
            :command_name => command_name,
            :room_name => room_map[m.room_id],
            :params => properties,
            :next_when_fail => next_when_fail,
            :state => is_hold ? 'hold' : 'init'
        )
      }
    end
  end
  
  def available_machine_ids
    app.machine_ids
  end

  def directive_templates
    pairs = (expression||"").strip.split(',').collect{ |item|
      k,v = item.squish.split('|')
      [k.to_i, v]
    }

    templates = DirectiveTemplate.where(:id => pairs.collect{|pair| pair[0]}.uniq).all.inject({}){|map, m|
      map.update( m.id => m)
    }
    pairs.each{|pair|
      if block_given? and templates[pair[0]]
        yield templates[pair[0]], pair[1] == "true"
      end
    }
  end

end
