# coding: utf-8
Given /创建了一个应用，名字是 (.+)/ do |name|
  @app = App.reals.create :name => name
end

Then /这个应用应该具备环境(.+)/ do |arg|
  arg.split(/,/).each do |name|
    @app.envs[name.strip].should_not be_nil
  end
end

Then /相关属性应该包括$/ do |table|
  table.hashes.each do |attrs|
    case attrs[:scope]
      when 'app' then
        @app.properties[attrs[:name]].should_not be_nil
      when 'env' then 
        @app.envs.each{|e| 
          e.properties[attrs[:name]].should_not be_nil 
        }
    end
  end
end
