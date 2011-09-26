# coding: utf-8
require 'spec_helper'

describe Machine do
  fixtures :machines,:rooms, :properties
  it "支持变更自身状态，同时生成下发指令" do
    m = Machine.create :name => 'localhost', :port => 22, :room => Room.first
    m.host.should == 'localhost'
    m.resume
    m.directives.count.should == 1
  end
  
  it "支持通过 env 访问生效的 property" do
    m = Machine.find(1)
    m.properties.should have_key('software')
    m.properties['software'].should == 'env 1 software'
  end
end
