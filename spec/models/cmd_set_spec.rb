require 'spec_helper'

describe CmdSet do
  fixtures :cmd_groups,:directive_templates,:users,:roles,:apps,:stakeholders,:operation_templates,:rooms,:machines
  it "can be create by cmd set def" do
    cs = App.first.operation_templates.first.create_cmd_set User.first
    cs.should_not be_nil
  end
  
end
