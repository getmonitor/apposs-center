require 'spec_helper'

describe Machine do
  fixtures :machines,:rooms
  it "should change its state and make directive" do
    m = Machine.create :name => 'localhost', :port => 22, :room => Room.first
    m.reload
    m.host.should == 'localhost'
    m.resume
  end
end
