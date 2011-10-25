# coding: utf-8
require 'spec_helper'

describe User do
  fixtures :users,:roles,:apps, :stakeholders
  it "执行赋权操作" do
    
    u = User.find 1
    
    u.is_admin?.should be_false
    # 返回值表示保存成功
    u.grant(Role::Admin,nil).new_record?.should == false
    # 重复赋权会导致保存失败
    u.grant(Role::Admin,nil).new_record?.should == true
    u.is_admin?.should be_true

    u.is_pe?(App.find(1)).should be_true
    u.ungrant(Role::PE, App.find(1)).should_not be_nil
    u.is_pe?(App.find(1)).should be_false
    u.grant(Role::PE, App.find(1)).new_record?.should == false
    u.is_pe?(App.find(1)).should be_true

    u.is_appops?(App.find(1)).should be_true
    u.ungrant(Role::APPOPS, App.find(1)).should_not be_nil
    u.is_appops?(App.find(1)).should be_false
  end
  
end
