# coding: utf-8
namespace :daily do

  task :default => [:app]

  desc "app sync"
  task :app => :environment do
    require 'digest/md5'
    require 'open-uri'
    require 'rexml/document'

    now  = Time.now
    sign = "taobao_daily%d%02d%02d" % [now.year, now.month, now.day]
    url  = "http://proxy.wf.taobao.org/DailyManage/tree-xml.ashx?sign=#{Digest::MD5.hexdigest(sign)}"
    body = open(url).read
    doc = REXML::Document.new body
    doc.get_elements('taobao/node/node').each { |e|
      store_app_node(e, 0, e.get_elements('node'))
    }
  end

  desc "load app's machines"
  task :machine => :environment do
    require 'tool/app_load.rb'
    loader = Tool::AppLoad.new App.reals.collect{|app| app.id }
    (0...2).to_a.collect{
      loader.add_loader
    }.each{|t| t.join}
  end

  private
    def store_app_node(e,parent_id, children)
      name = e.attributes['name']
      new_app = App.where(:name => name, :parent_id => parent_id).first
      if new_app.nil?
        p "新导入 #{parent_id}-#{name}"
        new_app = App.create(
            :name => name, :parent_id => parent_id, :virtual => (children.size > 0)
        )
      else
        p "已存在 #{parent_id}-#{name}"
      end

      ignore_dup(children).each{|child|
        store_app_node(child,new_app.id,child.get_elements('node'))
      }
    end
    
    def ignore_dup children
      duplicated_items = children.group_by{|e| e.attributes['name']}.select{|k,v| v.size > 1}.collect{|k,v| k}
      $stderr.puts "conflict: #{duplicated_items.join ','}" if duplicated_items.size > 0
      children.select{|e| not duplicated_items.include? e.attributes}
    end
end
