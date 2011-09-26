# coding: utf-8
require 'spec_helper'

describe Env do
  fixtures :apps, :envs, :properties
  it "与应用模型相关联，支持数组下标操作" do
    app = App.first
    app.envs['线上'].should_not be_nil
    app.envs['online'].should be_nil
    app.envs.create :name => 'online'
    app.envs['online'].should_not be_nil
  end
  
  it "支持访问自身的 property" do
    env = Env.first
    env.properties.count.should == 2
    env.enable_properties.count.should == 6
  end

  it "支持输出当前环境的配置项信息，允许覆盖" do
    env = Env.first
    enable_properties = env.enable_properties['software'] = 'env 1 software'
  end
end
