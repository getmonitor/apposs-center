require 'spec_helper'

describe Property do
  fixtures :properties,:apps,:rooms,:machines,:envs
  it "could be used in app/env/machine models" do
    Property.where(:resource_type => Property::GLOBAL).first.should_not be_nil
    App.first.properties.size.should eql(3)
    App.first.properties['software'].should == 'something'
    App.first.properties['version'].should == '2'
    App.first.envs.first.properties['version'].should == '1'
    m = Machine.find(1)
    m.properties.should have_key('software')
    m.properties['software'].should == 'other soft'
  end
end
