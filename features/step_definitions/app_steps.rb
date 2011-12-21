# coding: utf-8
Given /我创建了一个应用，名字是 (.+)/ do |name|
  @app = App.reals.create :name => name
end

Then /这个应用应该同时具备环境$/ do |table|
  table.hashes.each do |hash|
    @app.envs[hash[:name]].should_not be_nil
  end
end
