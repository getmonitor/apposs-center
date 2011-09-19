require 'open-uri'
require 'json'
module Tool

  class AppLoad
    def initialize ids
      @room_map = Room.all.group_by{|room| room.name}
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
      name = build_name app
      url  = "http://opsfree.corp.taobao.com:9999/products/dumptree?_username=droid/droid&notree=1&leafname=#{URI.escape name}"
      data = try_url url
      if data.size == 0
        $stderr.puts "没有发现数据: #{name} - #{url}"
        return
      end
      p "load #{app_id} #{name} - #{url}"

      data[0]["opsfree_product.#{name}"].each{|node_group_data|
#        node_group_name = node_group_data['nodegroup_info']['detail']['nodegroup_name']
        node_group_data['child'].each{|machine_data|
          room = get_and_update_room machine_data['site']
          attributes = {
            :host => machine_data['oob_ip'],
            :name => machine_data['nodename'],
            :room_id => room.id,
            :port => 22,
            :app_id => app_id
          }
          
          if ::Machine.where(attributes).first.nil?
            ::Machine.create(attributes)
          end
        }
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

    def hold app
      app.children.each{|child|
        hold child
      }
      app.hold
    end


  end
end
