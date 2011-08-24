require 'spec_helper'

describe Operation do
  fixtures :directive_groups,:directive_templates,:users,:roles,:apps,:stakeholders,:operation_templates,:rooms,:machines
  it "can be create by cmd set def" do
    app = App.first
    ot = app.operation_templates.first
    directive_count = ot.expression.split(",").count
    os = ot.create_operation User.first,nil
    os.directives.count.should == (directive_count * app.machines.count)
    os2 = ot.create_operation User.first,[1]
    os2.directives.count.should == directive_count
  end
  
end
