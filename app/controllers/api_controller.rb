class ApiController < ApplicationController
  def commands
  	room = Room.where(:name => params[:room_name]).first
    if room.nil?
      render :text => ""
    else
      # 查询参数包括机房的 name 和 id，是考虑到 room 表的name字段发生变动，
      # 此时应该谨慎处理，不下发相应的命令
      if params[:reload]
        oper_query = Directive.with_state(:init,:ready,:running)
      else
        oper_query = Directive.with_state(:init)
      end
      render :text => oper_query.where(:room_id => room.id, :room_name => room.name).collect{|directive|
        directive.download
        directive.invoke if directive.has_operation?
        "#{directive.machine_host}:#{directive.command_name}:#{directive.id}"
      }.join("\n")
    end
  end
  
  #{host,Host},{oid,DirectiveId}
  def run
    Directive.find(params[:oid]).invoke
    render :text => 'ok'
  end
  
  # {isok,atom_to_list(IsOk)},{host,Host},{oid,DirectiveId},{body,Body}
  def callback
    directive = Directive.where(:id => params[:oid]).first
    directive.callback(
        "true"==params[:isok], params[:body].gsub(/%a$/,'')
    ) if directive
  	render :text => 'ok'
  end
  
  def load_hosts
    hosts = params[:hosts].split("|")[0,9] #考虑到性能，仅取前10个，其余下次再获取
    render :text => Machine.where(:host => hosts).collect{|m|
      "host=#{m.host},port=#{m.port || 22},user=#{m.user},password=#{m.password},state=#{m.state}"
    }.join("\n")
  end
  
  def packages
    name,version,branch = params[:name], params[:version], params[:branch]
    software = Software.with_name(name).first
    if software and (app = software.app)
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
