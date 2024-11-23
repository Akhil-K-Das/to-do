class TaskMailer < ApplicationMailer
  def reminder_email(task)
    @task = task
    mail(
      to: @task.assignee.email,
      subject: 'Task Due Date Reminder',
      body: "Hello #{@task.assignee.email},\n\nThis is a reminder that your task titled '#{@task.title}' is due on #{@task.due_date}."
    )
  end
end
