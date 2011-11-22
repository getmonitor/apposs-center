class DirectiveTemplatesController < ResourceController

  def create
    group = DirectiveGroup['my_group']
    params[:directive_template].update(:directive_group_id => group.id)
    create!
  end

  def load_other
    @other_user = User.where(:email => params[:email]).first
    @directive_templates = @other_user.directive_templates if @other_user
  end

  def add_all
    @directive_templates = current_user.load_directive_templates(
      DirectiveTemplate.where( :id => params[:imported_ids])
    )
    @errors = @directive_templates.collect{|dt| dt.errors.to_a.collect{|msg| "#{dt.alias}: #{msg}"} }.flatten
  end

  protected
    def begin_of_association_chain
      current_user
    end
end

