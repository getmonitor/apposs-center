class ReleasePack < ActiveRecord::Base

  NAME = 'VERSION'

  belongs_to :app
  
  def vnumber
    version =~ /(\d+)(\.\d+)?$/
    $1
  end

  def use
    app.envs[NAME] = self.version
  end
end
