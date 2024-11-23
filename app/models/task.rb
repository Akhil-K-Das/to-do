class Task < ApplicationRecord
  belongs_to :assignee, class_name: 'User', optional: true
  belongs_to :workspace
  belongs_to :category
  has_one_attached :file
  validates :title, presence: true, length: { maximum: 255 }
  validates :due_date, comparison: { greater_than: Time.current }

  after_save_commit :broadcast_task
  after_save :schedule_task_reminder

  scope :filter_by_category, ->(category_id) { where(category_id: category_id) }
  scope :sort_by_priority, -> { order(priority: :asc) }
  scope :search, ->(query) {
    where('title ILIKE :query OR description ILIKE :query', query: "%#{query}%") if query.present?
  }

  private

  def broadcast_task
    ActionCable.server.broadcast("tasks_#{workspace.id}", self)
  end

  def schedule_task_reminder
    # Ensure a valid reminder time is set
    if remind_before_at.present? && remind_before_at > Time.current
      # Schedule the job to run at `remind_before_at`
      ReminderJob.set(wait_until: remind_before_at).perform_later(id)
    end
  end
end
