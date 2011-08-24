require 'spec_helper'

describe Software do
  fixtures :apps,:softwares
  it "app has its softwares" do
    app = App.first
    app.softwares.count.should == 1
  end
end
