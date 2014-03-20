class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :posts
  before_create :set_member 
  mount_uploader :avatar, AvatarUploader

  def role?(base_role)
    role == base_role.to_s
  end
  
  private

  def set_member
    self.role = 'member'
  end
  
end
