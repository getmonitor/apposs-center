# coding: utf-8
require 'spec_helper'

describe Property do
  fixtures :properties
  it "支持 global property" do
    Property.global.where( :name => 'root').first.value.should == '/home/a'
    Property.global.where( :name => 'conf_file').first.value.should == '/home/a/conf/pe.conf'
  end
  
  it "支持输出 hash" do
    Property.global.pairs['root'].should == '/home/a'
    Property.global.pairs['conf_file'].should == '/home/a/conf/pe.conf'
  end
  
  it "property名称不能重复" do
    prop = Property.global.first
    new_prop = Property.global.new :name => prop.name, :value => "other"
    new_prop.valid?.should be_false
    new_prop.name = "another " + prop.name
    new_prop.valid?.should be_true
  end
end
