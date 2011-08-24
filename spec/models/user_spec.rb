require 'spec_helper'

describe User do
  fixtures :users,:roles,:apps,:stakeholders
  it "user has correct role" do
    u = User.find 1
    u.is_admin?.should be_false
    u.roles << Role.find_by_name(Role::Admin)
    u.is_admin?.should be_true
  end
end
