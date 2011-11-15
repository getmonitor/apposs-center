# coding: utf-8
require 'spec_helper'

describe Env do
  fixtures :apps, :envs, :properties
  it "支持访问自身的 property" do
    env = Env.first
    env.properties.count.should == 3
    env.enable_properties.count.should == 9

    env.properties[:a] = 'b'
    env.reload
    env.properties[:a].should == 'b'
    
    env.properties[:a, :b] = true
    env.reload
    env.properties(:name => :a).first.locked.should be_true
  end

  it "支持输出当前环境的配置项信息，允许覆盖" do
    env = Env.first
    enable_properties = env.enable_properties['software'] = 'env 1 software'
  end
  
  it "支持用文件更新当前环境的配置信息" do
    env = Env.first
    env.properties.destroy_all

    env.reload #清理对象缓存
    env.property_file = File.new "#{Rails.root}/spec/fixtures/env_property.txt"
    env.save.should be_true

    env.reload #清理对象缓存
    env.properties['url'].should == 'www.alimama.com'
    env.properties.size.should == 5
    env.properties.destroy_all
    env.property_file = nil
    env.save.should be_true

    env.reload #清理对象缓存
    env.properties['url'].should be_nil
  end
  
  it "支持直接更新当前环境的配置信息" do
    env = Env.first
    env.properties.destroy_all

    env.reload #清理对象缓存
    env.property_content = %Q|
[config]
url=www.alimama.com
status=/home/a/project/cps/deploy/cps/status_ns.html
package=t_site_taobaoke
package_addr=http://yum.corp.taobao.com/taobao/5/noarch/current//t_site_taobaoke/t_site_taobaoke-1.0.19-170.noarch.rpm
newpackage=t_site_taobaoke-1.0.19-170.noarch.rpm
|
    env.save.should be_true

    env.reload #清理对象缓存
    env.properties['url'].should == 'www.alimama.com'
    env.properties.size.should == 5
    env.properties.destroy_all
    env.property_content = nil
    env.save.should be_true

    env.reload #清理对象缓存
    env.properties['url'].should be_nil
  end
  
  it "合并配置信息" do
    env = Env.first
    env.sync_profile do |data|
      data.include?('root').should be_true
      data.include?('app_id').should be_true
      data.include?('env_id').should be_true
    end
  end
  
  it "创建env时增加缺省的env_id property" do
    app = App.first
    env = app.envs.create :name => 'not_exist'
    env.properties.count.should == 1
    env.reload
    env.properties[:env_id].should == env.id.to_s
    env.properties(:name => :env_id).first.locked.should == true
  end
end
