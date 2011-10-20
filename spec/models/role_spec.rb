# coding: utf-8
require 'spec_helper'

describe Role do

  fixtures :users,:roles,:apps,:stakeholders

  it "执行正确的基本操作" do
    role = Role[Role::Admin]
    role.name.should == Role::Admin
    
    new_role = Role.create(:name => Role::Admin)
    new_role.valid?.should be_false
    new_role.errors.size.should == 1
    new_role.errors[:name].first.should == '已经被使用'

  end

end
