class WorkspaceUser < ApplicationRecord
  belongs_to :workspace
  belongs_to :user

  # validates :role, inclusion: { in: %w[admin member] }
end
