class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :acls, :class_name => 'Stakeholder' do
    def [] name
      self.where(:resource_type => name).includes([:resource])
    end
  end
  
  has_many :apps, :through => :acls, :source => :resource, :source_type => 'App'
  has_many :roles,:through => :acls
  
  has_many :operations, :foreign_key => "operator_id"

  def is_admin?
    not acls.where(:role_id => Role[Role::Admin]).first.nil?
  end
  
end
