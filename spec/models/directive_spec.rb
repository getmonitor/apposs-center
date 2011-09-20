require 'spec_helper'

describe Directive do

  fixtures :operations, :machines, :operation_templates

  it "can be succeed in its life cycle" do
    dd = create_and_change_state
    dd.callback(true, "hello")
    dd.state.should == 'done'
  end

  it "maybe fail in its life cycle" do
    dd = create_and_change_state
    dd.callback(false, "hello")
    dd.state.should == 'failure'
    dd.operation.state.should == 'failure'
    dd.ack
    dd.state.should == 'done'
  end
  
  it "can invoke ok of its operation" do
    app = App.first
    o = app.operation_templates.last.gen_operation User.first, app.machines.collect{|m| m.id}[0..1]
    o.state.should == 'init'
    o.directives.each{ |dd|
      dd.download; dd.state.should == 'ready'
      dd.invoke; dd.state.should == 'running'
      dd.ok; dd.state.should == 'done'
    }
    o.reload
    o.state.should == 'done'
  end
  
  def create_and_change_state
    host = 'localhost'
    machine = Machine.where(:host => host).first
    dd = Directive.create :operation_id => 1, :machine_host => host, :machine => machine
    dd.state.should == 'init'
    dd.download
    dd.state.should == 'ready'
    dd.invoke
    dd.state.should == 'running'
    dd
  end
end
