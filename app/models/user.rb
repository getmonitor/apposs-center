class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :stakeholders
  has_many :apps, :through => :stakeholders, :source => :app, :conditions => ['parent_id is null']
  has_many :roles, :through => :stakeholders, :source => :role

  has_many :operations, :foreign_key => "operator_id"

  def is_admin?
    roles.where(:name => Role::Admin).count > 0
  end
end
