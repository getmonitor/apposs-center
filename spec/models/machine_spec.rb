# coding: utf-8
require 'spec_helper'

describe Machine do
  fixtures :machines,:rooms, :properties, 
           :directive_groups, :directive_templates, :operation_templates,
           :users, :roles, :apps, :stakeholders
  it "支持变更自身状态，同时生成下发指令" do
    m = Machine.create :name => 'localhost', :port => 22, :room => Room.first
    m.host.should == 'localhost'
    m.send_reset
    m.directives.first.command_name.should == 'machine|reset'
  end
  
  it "支持通过 env 访问生效的 property" do
    m = Machine.find 1
    m.properties.should have_key('software')
    m.properties['software'].should == 'env 1 software'
  end
  
  it "支持更改所属的app" do
    app = App.find 1
    m = app.machines.find 1

    app.
      operation_templates.where(:name => 'upgrade package').first.
      gen_operation User.first, [m.id]

    m.directives.count.should > 0

    m.reassign 2
    m.app.should == App.find(2)
    
    m.directives.each do |dd|
      dd.operation_id.should == Operation::DEFAULT_ID
    end
  end
end
