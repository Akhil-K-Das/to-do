class Workspace < ApplicationRecord
  has_many :workspace_users, dependent: :destroy
  has_many :users, through: :workspace_users

  before_create :generate_api_key

  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates :url, presence: true, uniqueness: true

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(20)
  end
end
