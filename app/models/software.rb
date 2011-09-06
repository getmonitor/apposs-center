class Software < ActiveRecord::Base
  
  NAME = 'software'

  belongs_to :app

  validates_presence_of :name

  after_create :update_env

  def update_env
    app.envs[NAME] = name
  end
end
