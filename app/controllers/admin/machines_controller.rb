class Admin::MachinesController < Admin::BaseController
  def index
    machines = Machine.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = Machine.all.count
    machines = machines.collect do |m|
      m.serializable_hash.delete_if {|k,v| k == 'password'}
    end
    respond_with :totalCount => total, :machines => machines
  end

  def show
    respond_with Machine.find(params[:id])
  end

  def create
    #machine = Machine.create(params[:machine])
    m = Machine.create(params[:machine])
    m = m.attributes.update(
        "errors" => m.errors
    )
    render :text => m.to_json
  end

  def update
    m = Machine.find(params[:id])
    m.update_attributes(params[:machine])
    m = m.attributes.update(
        "errors" => m.errors
    )
    render :text => m.to_json
  end

  def destroy
    respond_with Machine.find(params[:id]).delete
  end
end