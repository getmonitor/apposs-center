class ReleasePack < ActiveRecord::Base
  belongs_to :app
  
  def vnumber
    version =~ /(\d+)(\.\d+)?$/
    $1
  end
  
  state_machine :state, :initial => :init do
    event :use   do transition :init  => :using end
    event :off   do transition :using => :used  end
    event :reuse do transition :used  => :using end
    
    after_transition :on => [:use,:reuse], :do => :offline_others
  end
  
  def offline_others
    id = self.id
    app.packages.with_state(:using).each{|pack|
      pack.off if pack.id != id
    }
  end
end
