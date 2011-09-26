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
end
