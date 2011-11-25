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
      @ids.each do | app_id |
        do_load app_id
      end
    end

    def do_load app_id
      app = App.find app_id
      env_obj = app.envs[:online,true]
      
      Rails.logger.info "app: #{app}, env: #{env_obj}"
      name = build_name app
      url  = "http://opsfree.corp.taobao.com:9999/products/dumptree?_username=droid/droid&notree=1&leafname=#{URI.escape name}"
      data = try_url url
      if data.size == 0
        $stderr.puts "没有发现数据: #{name} - #{url}"
        return
      end
      Rails.logger.info "load #{app_id} #{name} - #{url}"
      
      root_node = data[0]["opsfree_product.#{name}"]

      root_node.each{|node_group_data|
        node_group_data['child'].each{|machine_data|
          room = get_and_update_room machine_data['site']
          attributes = {
            :host => extract_host(machine_data),
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
                Rails.logger.info "移动机器：#{m.app_id} -> #{app_id}"
                m.reassign(app_id)
              else
                m.online
                Rails.logger.info "机器已存在 - #{machine_data['nodename']}"
              end
              m.update_attributes attributes
            end
          else
            Rails.logger.info "未知的机器状态：#{machine_data['state']}"
          end

        }
      }
      
      (current_machine_list(app) - real_machine_list(root_node)).each{|name|
        # 相同name的机器只有一台
        Rails.logger.info "机器下线: #{name}"
        machine = Machine.where(:name => name).first
        if machine
          machine.offline
        else
          Rails.logger.info "机器不存在: #{name}"
        end
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
  
    def extract_host machine_data
      machine_data['dns_ip'].blank? ? machine_data['nodename'] : machine_data['dns_ip']
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

  end
end
