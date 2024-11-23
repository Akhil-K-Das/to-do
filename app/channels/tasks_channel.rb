class TasksChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tasks_#{params[:workspace]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
