class Room < ActiveRecord::Base
  has_many :machines, :dependent => :nullify

  def self.search(per_page, page)
    rooms = paginate :per_page => per_page.to_i, :page => page.to_i
    '{"totalCount":"'+Room.all.count.to_s + '","rooms":' + rooms.to_json + '}'
  end

  def to_s
    send :name
  end
end
