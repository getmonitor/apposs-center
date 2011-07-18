class RoomsController < InheritedResources::Base
  actions :all, :except => [ :edit, :update, :destroy, :new ]
  
  def attributes
  	[:name]
  end
end