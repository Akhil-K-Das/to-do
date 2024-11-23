class ReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find(task_id)
    TaskMailer.reminder_email(task).deliver_now
  end
end