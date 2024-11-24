class GoogleCalendarService
  def initialize(user)
    @user = user
    @client = Google::Apis::CalendarV3::CalendarService.new
    @client.authorization = user.google_token
  end

  def create_event(task)
    event = Google::Apis::CalendarV3::Event.new(
      summary: task.title,
      description: task.description,
      start: { date_time: task.due_date.to_datetime.rfc3339 },
      end: { date_time: (task.due_date + 1.hour).to_datetime.rfc3339 }
    )
    @client.insert_event('primary', event)
  end
end
