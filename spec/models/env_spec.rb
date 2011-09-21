require 'spec_helper'

describe Env do
  fixtures :apps
  it "could be used with app model" do
    app = App.first
    app.envs['online'].should be_nil
    app.envs.create :name => 'online'
    app.envs['online'].should_not be_nil
  end
end
