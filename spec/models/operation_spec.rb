require 'spec_helper'

describe Operation do
  fixtures :directive_groups,:directive_templates,:users,:roles,:apps,:stakeholders,:operation_templates,:rooms,:machines
  it "can be create by cmd set def" do
    cs = App.first.operation_templates.first.create_operation User.first
    cs.should_not be_nil
  end
  
end
