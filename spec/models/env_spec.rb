# coding: utf-8
require 'spec_helper'

describe Env do
  fixtures :apps
  it "与应用模型相关联，支持数组下标操作" do
    app = App.first
    app.envs['online'].should be_nil
    app.envs.create :name => 'online'
    app.envs['online'].should_not be_nil
  end
end
