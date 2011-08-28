class DirectiveTemplate < ActiveRecord::Base
  GLOBAL_ID = 0

  belongs_to :directive_group

end
