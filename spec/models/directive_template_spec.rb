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
  
  it '成功创建 download 指令' do
    env = App.first.envs['线上']
    env.properties[:env_id].should == '1'
    
    Property.global.pairs[:env_id].should be_nil
    env.app.properties.pairs[:env_id].should be_nil
    env.properties.pairs['env_id'].should == '1'
    
    
    directive = DirectiveGroup['default'].directive_templates['download'].gen_directive(
      :machine_id => 23,
      :params => env.enable_properties
    )
    directive.command_name.should == 'mkdir -p `dirname /home/test/conf/pe.conf` && wget "http://127.0.0.1:9999/store/1/1/pe.conf" -O "/home/test/conf/pe.conf"'
  end
end


