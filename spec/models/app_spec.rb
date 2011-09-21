require 'spec_helper'

describe App do
  fixtures :users,:apps
  it "should transit well" do
    app = App.first
    app.should_not be_nil
    app.state.should == 'running'
    app.pause
    app.state.should == 'hold'
    app.use
    app.state.should == 'running'
    app.stop
    app.state.should == 'offline'
  end
end
