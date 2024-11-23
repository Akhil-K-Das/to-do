class User < ApplicationRecord
  has_many :workspace_users, dependent: :destroy
  has_many :workspaces, through: :workspace_users
  has_many :tasks, foreign_key: 'assignee' 

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  after_create :send_signup_email
  
  private

  def send_signup_email
    UserMailer.signup_confirmation(self).deliver_later
  end
  
end
