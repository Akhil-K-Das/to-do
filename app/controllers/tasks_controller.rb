class TasksController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :task_not_found

  def index
    tasks = @current_workspace.tasks.search(params[:query]).page(params[:page]).per(params[:per_page] || 10)
    tasks = tasks.page(params[:page]).per(params[:per_page] || 10) # Defaults to 10 items per page
    tasks = tasks.filter_by_category(params[:category_id]) if params[:category_id]
    tasks = tasks.sort_by_priority if params[:sort_by] == 'priority'
    render json: {
      tasks: tasks,
      meta: {
        current_page: tasks.current_page,
        total_pages: tasks.total_pages,
        total_count: tasks.total_count
      }
    }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def create
    task = @current_workspace.tasks.new(task_params)
    if params[:file]
      task.file.attach(params[:file])
    end
  
    if task.save
      render json: task, status: :created
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end  

  private

  def task_not_found
    render json: { error: "Task not found." }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority, :category_id, :assignee_id, :workspace_id)
  end
end
