require 'spec_helper'

describe ReleasePack do
  fixtures :apps,:release_packs
  it "release pack can switch its version" do
    app = App.first
    app.release_packs.with_state(:init).count.should == 3
    pack1 = app.release_packs.with_state(:init).first
    pack2 = app.release_packs.with_state(:init).last
    pack1.use
    pack1.state.should == 'using'
    pack2.use
    pack2.state.should == 'using'
    pack1.reload #根据id装载新的数据
    pack1.state.should == 'used'
  end
  
end
