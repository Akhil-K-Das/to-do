class WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: %i[show update destroy add_member]
  before_action :authorize_workspace_admin, only: %i[update destroy add_member]

  # List all workspaces the user belongs to
  def index
    workspaces = current_user.workspaces
    render json: workspaces, status: :ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # Show a specific workspace
  def show
    render json: @workspace, status: :ok
  end

  # Create a new workspace
  def create
    workspace = current_user.workspaces.new(workspace_params)

    if workspace.save
      # Automatically make the creator an admin
      WorkspaceUser.create!(workspace: workspace, user: current_user, role: 'admin')
      token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil)[0] # Generate token
      render json: { token: token, user: current_user, workspace: workspace }, status: :created
    else
      Rails.logger.info("Workspace Creation Errors: #{workspace.errors.full_messages}")
      render json: { error: workspace.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update an existing workspace
  def update
    if @workspace.update(workspace_params)
      render json: @workspace, status: :ok
    else
      render json: { error: @workspace.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a workspace
  def destroy
    @workspace.destroy
    head :no_content
  end

  # Add a team member to the workspace
  def add_member
    user = User.find_by(email: params[:email])

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    # Add the user as a member (default role)
    WorkspaceUser.create!(workspace: @workspace, user: user, role: params[:role] || 'member')
    render json: { message: 'User added successfully' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:id])
  end

  def workspace_params
    params.require(:workspace).permit(:name, :url)
  end

  def authorize_workspace_admin
    unless @workspace.users.exists?(id: current_user.id, workspace_users: { role: 'admin' })
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
end
