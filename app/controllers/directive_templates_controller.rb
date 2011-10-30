class DirectiveTemplatesController < ResourceController

  def create
    group = DirectiveGroup['my_group']
    
    params[:directive_template].update(:directive_group_id => group.id)
    create!
  end

  protected
    def begin_of_association_chain
      current_user
    end
end

