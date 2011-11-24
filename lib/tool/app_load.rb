# coding: utf-8
require 'open-uri'
require 'json'
module Tool

  class AppLoad
    def initialize ids
      result = {}
      Room.all.each{ |room| result.update(room.name => room) }
      @room_map = result
      @ids = ids
      @room_lock = Mutex.new
      @id_lock = Mutex.new
    end

    def add_loader
      Thread.new do |t|
        while(app_id = get_id())
          do_load app_id
        end
      end
    end

    def get_id
      @id_lock.synchronize{
        @ids.shift
      }
    end

    def do_load app_id
      app = App.find app_id
      env_obj = app.envs[:online,true]
      
      p "app: #{app}, env: #{env_obj}"
      name = build_name app
      url  = "http://opsfree.corp.taobao.com:9999/products/dumptree?_username=droid/droid&notree=1&leafname=#{URI.escape name}"
      data = try_url url
      if data.size == 0
        $stderr.puts "没有发现数据: #{name} - #{url}"
        return
      end
      p "load #{app_id} #{name} - #{url}"
      
      root_node = data[0]["opsfree_product.#{name}"]

      root_node.each{|node_group_data|
        node_group_data['child'].each{|machine_data|
          room = get_and_update_room machine_data['site']
          attributes = {
            :host => machine_data['dns_ip'],
            :name => machine_data['nodename'],
            :room_id => room.id,
            :port => 22,
            :app_id => app_id,
            :env_id => env_obj.id
          }
          
          if machine_data['state']=='working_offline'
            ::Machine.where(:name => machine_data['nodename']).each do |m|
              m.offline
            end
          elsif machine_data['state']=='working_online'
            m = ::Machine.unscoped.where(:name => machine_data['nodename']).first
            if m.nil?
              ::Machine.create(attributes)
            else
              if m.app_id != app_id
                p "移动机器：#{m.app_id} -> #{app_id}"
                m.reassign(app_id)
              else
                m.online
                p "机器已存在 - #{machine_data['nodename']}"
              end
              m.update_attributes attributes
            end
          else
            p "未知的机器状态：#{machine_data['state']}"
          end

        }
      }
      
      (current_machine_list(app) - real_machine_list(root_node)).each{|name|
        # 相同name的机器只有一台
        p "机器下线: #{name}"
        Machine.where(:name => name).first.offline
      }

    end

    def try_url(url)
      data = nil
      3.times.each{
        begin
          data = JSON.parse open(url).read
        rescue
          sleep 1
        else
          break
        end
      }
      data || []
    end

    def get_and_update_room room_name
      @room_lock.synchronize{
        if (room = @room_map[room_name]).nil?
          room = Room.create( :name => room_name )
          @room_map.update(room_name => room)
        end
        room
      }
    end

    def build_name(app)
      name = app.name
      while(app.parent_id > 0)
        app = app.parent
        name = "#{app.name}.#{name}"
      end
      "淘宝网.#{name}"
    end
  
    def current_machine_list app
      app.machines.select(:name).collect{|m| m.name}
    end

    def real_machine_list root_node
      root_node.map{|node_group_data|
        node_group_data['child'].map{|machine_data|
          machine_data['nodename'] if machine_data['state']=='working_online'
        }
      }.flatten.reject{|item| item.nil? }
    end

    def hold app
      app.children.each{|child|
        hold child
      }
      app.hold
    end


  end
end
