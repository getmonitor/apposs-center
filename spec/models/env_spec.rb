# coding: utf-8
require 'spec_helper'

describe Env do
  fixtures :apps, :envs, :properties
  it "与应用模型相关联，支持数组下标操作" do
    app = App.first
    app.envs['线上'].should_not be_nil
    app.envs['online'].should be_nil
    app.envs.create :name => 'online'
    app.envs['online'].should_not be_nil
  end
  
  it "支持访问自身的 property" do
    env = Env.first
    env.properties.count.should == 3
    env.enable_properties.count.should == 9
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
  
  it "合并、下载配置信息" do
    env = Env.first
    env.download_properties
    directive_template_id = DirectiveGroup['default'].directive_templates['download'].id
    env.machines{|directive|
      directive.directive_template_id.should == directive_template_id
    }
  end
end
