# coding: utf-8
require 'spec_helper'

describe DirectiveTemplate do

  fixtures :directive_templates, :directive_groups, :apps, :envs, :properties
  it '创建内置指令' do
    directive = DirectiveGroup['default'].directive_templates['inner'].gen_directive(
      :machine_id => 23
    )
    directive.command_name.should == 'do inner'
  end
  
  it '成功创建 sync_profile 指令' do
    env = App.first.envs['线上']
    env.properties[:env_id].should == '1'
    
    directive = DirectiveGroup['default'].directive_templates['sync_profile'].gen_directive(
      :machine_id => 23,
      :params => env.enable_properties
    )
    directive.command_name.should == 'mkdir -p `dirname /home/test/conf/pe.conf` && wget "http://127.0.0.1:9999/store/1/1/pe.conf" -O "/home/test/conf/pe.conf"'
  end

  it '成功创建 machine|reset 指令' do
    env = App.first.envs['线上']
    machine = env.machines.create :name => 'for_directive_test', :port => 22

    directive = DirectiveGroup['default'].directive_templates['machine|reset'].gen_directive(
      :machine => machine
    )
    machine.reload
    machine.directives.count.should == 1
    machine.directives.first.command_name.should == 'machine|reset'
  end
end

