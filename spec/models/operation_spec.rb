# coding: utf-8
require 'spec_helper'

describe Operation do
  fixtures :directive_groups, :directive_templates,
           :users, :roles, :apps, :stakeholders,
           :operation_templates,:rooms,:machines
  it "从操作模板中创建一个普通的操作" do
    app = App.first
    ot = app.operation_templates.where(:name => 'upgrade package').first
    directive_count = ot.expression.split(",").count
    directive_count.should == 3
    oper = ot.gen_operation User.first, nil
    oper.directives.count.should == (directive_count * app.machines.count)
    machine = Machine.first
    oper2 = ot.gen_operation User.first,[machine.id]
    oper2.directives.count.should == directive_count
    oper2.directives.first.machine.should == machine
  end
  
  it "创建一个自动继续的操作序列" do

    operations = build_operation_sequence(false)
    
    first = operations.first
    second = first.next
    second.state.should == 'wait'

    complete_an_operation first
    
    first.reload
    first.state.should == 'done'
    second.reload
    second.state.should == 'init'
  end
  
  it "创建一个人工继续的操作序列" do
    operations = build_operation_sequence(true)
    
    first = operations.first
    second = first.next
    second.state.should == 'hold'

    complete_an_operation first
    
    first.reload
    first.state.should == 'done'
    second.reload
    second.state.should == 'hold'
  end
  
  def build_operation_sequence is_hold
    old_count = Directive.count
    app = App.first
    ot = app.operation_templates.last
    directive_count = ot.expression.split(",").count
    directive_count.should == 2
    user = User.first
    previous_id = nil
    user = User.first
    ss = app.machines.collect{|m| m.id}.collect{|x| [x]}
    ss.size.should == 4
    operations = ss.collect{|id_group|
      operation_on_bottom = ot.gen_operation(user, id_group, previous_id, is_hold )
      previous_id = operation_on_bottom.id
      operation_on_bottom
    }
    first = operations.first
    first.enable
    first.state.should == "init"
    Directive.count.should == old_count + ss.size * directive_count
    operations
  end
  
  def complete_an_operation operation
    operation.directives.each{|dire|
      dire.download && dire.invoke && dire.ok
    }
    operation
  end
end
