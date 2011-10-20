# coding: utf-8
require 'spec_helper'

describe App do
  fixtures :users,:apps,:properties,:envs
  it '能够正确执行状态迁移' do
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
  
  it '支持访问自身 property' do
    App.first.properties.size.should == 4
    App.first.properties['software'].should == 'app 1 software'
    App.first.properties['version'].should == '2'
    App.first.envs.first.properties['version'].should == '1'
  end
end
