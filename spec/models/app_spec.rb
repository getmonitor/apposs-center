require 'spec_helper'

describe App do
  fixtures :users,:apps
  it "should exist" do
    App.count.should  == 1
  end
end
