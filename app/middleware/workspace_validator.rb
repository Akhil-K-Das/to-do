class WorkspaceValidator
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    workspace_id = request.get_header('HTTP_X_WORKSPACE') # Header keys are prefixed with HTTP_ in Rack

    if workspace_id.present?
      # Find the workspace by ID or other identifier (e.g., name or API key)
      workspace = Workspace.find_by(id: workspace_id)

      if workspace
        # Store the workspace in the environment for later use
        env['current_workspace'] = workspace
      else
        # If the workspace is not found, return a 404 response
        return [404, { 'Content-Type' => 'application/json' }, [{ error: 'Workspace not found' }.to_json]]
      end
    else
      # If the header is missing, return a 400 Bad Request response
      return [400, { 'Content-Type' => 'application/json' }, [{ error: 'x-workspace header is missing' }.to_json]]
    end

    @app.call(env) # Pass the request to the next middleware/controller
  end
end
