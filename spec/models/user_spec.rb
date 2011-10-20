# coding: utf-8
require 'spec_helper'

describe User do
  fixtures :users,:roles,:apps,:stakeholders
  it "具备正确的权限" do
    u = User.find 1
    
    u.acls.count.should == 2

    u.apps.first.should == App.first
    u.is_admin?.should be_false

    u.roles << Role.find_by_name(Role::Admin)
    u.is_admin?.should be_true

  end
  
end
