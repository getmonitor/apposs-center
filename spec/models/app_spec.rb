require 'spec_helper'

describe App do
  fixtures :users
  it "should has its directives" do
    App.all.each{|app|
      app.directives.should be_empty
    }
  end
end
