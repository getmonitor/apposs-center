require 'spec_helper'

describe ReleasePack do
  fixtures :apps,:packages
  it "package can switch its version" do
    app = App.first
    app.packages.with_state(:init).count.should == 3
    pack1 = app.packages.with_state(:init).first
    pack2 = app.packages.with_state(:init).last
    pack1.use
    pack1.state.should == 'using'
    pack2.use
    pack1.state.should == 'used'
    pack2.state.should == 'using'
  end
  
end
