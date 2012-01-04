# coding: utf-8
require 'spec_helper'

describe Machine do
  fixtures :machines,:rooms, :properties, 
           :directive_groups, :directive_templates, :operation_templates,
           :users, :roles, :apps, :stakeholders, :envs

  describe '状态变迁支持' do
    before :each do
      @m = Machine.create :name => 'localhost', :port => 22, :room => Room.first
      @m.host.should == 'localhost'
    end
    it '生成下发指令' do
      %w{pause reset interrupt reconnect clean_all}.each do |event|
        @m.send "send_#{event}".to_sym
        @m.directives.last.command_name.should == "machine|#{event}"
      end
    end
    
    it '上报新的状态' do
      {
        :reset => :normal, 
        :disconnect => :disconnected,
        :pause => :paused
      }.each_pair do |event,state|
        @m.send event
        @m.reload.state.should == state.to_s
      end
    end
  end
  
  describe '关联对象处理' do
    before :each do
      @app = App.find 1
      @m = @app.machines.find 1
    end
    it "支持通过 env 访问生效的 property" do
      @m.properties.should have_key('software')
      @m.properties['software'].should == 'env 1 software'
    end
    
    it "支持更改所属的app" do
      @app.
        operation_templates.where(:name => 'upgrade package').first.
        gen_operation User.first, [@m.id]

      @m.directives.count.should > 0

      @m.reassign 2
      @m.app.should == App.find(2)
      @m.app.envs.should include(@m.env)
      
      @m.directives.each do |dd|
        dd.operation_id.should == Operation::DEFAULT_ID
      end
    end
  end
end
