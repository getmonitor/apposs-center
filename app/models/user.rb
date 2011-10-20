class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :acls, :class_name => 'Stakeholder'
  has_many :apps, :through => :acls, :source => :app
  has_many :roles, :through => :acls, :source => :role

  has_many :operations, :foreign_key => "operator_id"

  def is_admin?
    not roles.where(:name => Role::Admin).first.nil?
  end
end
