class ApiController < ApplicationController
  def commands
  	room = Room.where(:name => params[:room_name]).first
  	# 查询参数包括机房的 name 和 id，是考虑到 room 表的name字段发生变动，
  	# 此时应该谨慎处理，不下发相应的命令
    if params[:reload]
      operQuery = Directive.with_state(:init,:ready,:running)
    else
      operQuery = Directive.with_state(:init)
    end
  	render :text => operQuery.where(:room_id => room.id, :room_name => room.name).collect{|o|
  		o.download
  		"#{o.machine_host}:#{o.command_name}:#{o.id}"
  	}.join("\n")
  end
  
  #{host,Host},{oid,DirectiveId}
  def run
    Directive.find(params[:oid]).invoke
    render :text => 'ok'
  end
  
  # {isok,atom_to_list(IsOk)},{host,Host},{oid,DirectiveId},{body,Body}
  def callback
    Directive.find(params[:oid]).callback(
        "true"==params[:isok], params[:body]
    )
  	render :text => 'ok'
  end
  
  def load_hosts
    hosts = params[:hosts].split("|")[0,9] #考虑到性能，仅取前10个，其余下次再获取
    render :text => Machine.where(:host => hosts).collect{|m|
      "host=#{m.host},port=22,user=#{m.user},password=#{m.password}"
    }.join("\n")
  end
  
  def packages
    name,version,branch = params[:name], params[:version], params[:branch]
    app = App.find_by_name name
    if app
      if request.post?
        app.release_packs.create :version => version, :branch => branch
        render :text => "ok"
      else
        if pack = app.release_packs.with_state(:using).first
          render :text => pack.version
        else
          render :text => ""
        end
      end
    else
      render :text => "no_app"
    end
  end
end
