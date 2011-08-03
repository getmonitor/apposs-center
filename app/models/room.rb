class Room < ActiveRecord::Base
  has_many :machines, :dependent => :nullify

  def to_s
    send :name
  end
end
