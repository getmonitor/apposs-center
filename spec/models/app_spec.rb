# coding: utf-8
require 'spec_helper'

describe App do
  fixtures :users,:apps,:properties,:envs
  
  describe "关联对象" do

    before(:each) do
      @app = App.reals.first
    end

    it 'env (支持不存在时创建)' do
      count = @app.envs.count
      @app.envs[:unknown].should be_nil
      @app.envs.count.should == count
      @app.envs[:unknown,true].should_not be_nil
      @app.envs.count.should == count + 1
    end
    
    it '支持访问自身 property' do
      @app.properties.size.should == 4
      @app.properties['software'].should == 'app 1 software'
      @app.properties['version'].should == '2'
      @app.envs.first.properties['version'].should == '1'

      @app.properties[:a].should be_nil
      @app.properties[:a, :b] = true
      @app.reload
      @app.properties.where(:name => :a).first.locked.should be_true
    end
    
  end
  
  it '执行状态迁移' do
    app = App.reals.first
    app.should_not be_nil
    app.state.should == 'running'
    app.pause
    app.state.should == 'hold'
    app.use
    app.state.should == 'running'
    app.stop
    app.state.should == 'offline'
  end
  
  describe '应用创建' do

    before(:each) do
      @app = App.create :name => 'a_new_app'
    end

    it '自动创建缺省 env ：online、pre' do
      @app.envs.count
      @app.envs[:online].should_not be_nil
      @app.envs[:pre].should_not be_nil
    end

    it '自动创建相关 property' do
      @app.properties[:app_id].should == @app.id.to_s
      @app.properties.where(:name => :app_id).first.locked.should be_true
      @app.add_default_property #测试修改能力
      @app.reload
      @app.properties.where(:name => :app_id).first.locked.should be_true
    end
  end

end
