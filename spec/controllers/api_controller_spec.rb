# coding: utf-8
require 'spec_helper'

describe ApiController do

#  render_views
  
  describe "获取所有指令" do
    fixtures :directive_groups, :directive_templates,
             :users, :apps,
             :operation_templates,:rooms,:machines
  
    it "没有新的指令" do
      get :commands,:room_name => 'CNZ'
      response.body.to_s.should be_empty
    end
    
    it "有新的指令" do
      app = App.first
      ot = app.operation_templates.where(:name => 'upgrade package').first
      oper = ot.gen_operation User.first, app.machines.collect{|m| m.id}

      app.machines.collect{|m| m.room_id}.uniq.each do |room_id|
        room = Room.find room_id
        machine_count = app.machines.where(:room_id => room_id).count
        amount = ot.expression.split(/,/).count * machine_count
        get :commands, :room_name => room.name
        response.should be_success
        response.body.split(/\n/).count.should == amount
      end
    end
  end

  describe "变更机器状态" do
    it "访问已存在的机器" do
      m = Machine.first
      {
        :reset => :normal, 
        :disconnect => :disconnected,
        :pause => :paused
      }.each_pair do |event,state|
        get :machine_on, :host => m.host, :event => event.to_sym
        response.should be_success
        response.body.should == "true"
        m.reload.state.should == state.to_s
      end
    end

    it "访问不存在的机器" do
      m = Machine.first
      get :machine_on, :host => "unknown host", :state => :pause
      response.status.should == 404
    end
  end
end
