class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    token = request.get_header("HTTP_AUTHORIZATION")
    workspace = request.get_header("HTTP_X_WORKSPACE")

    user = User.find_by(token: token)
    workspace_record = Workspace.find_by(name: workspace)

    return [ 401, { "Content-Type" => "application/json" }, [ "Unauthorized" ] ] unless user && workspace_record

    env["current_user"] = user
    env["current_workspace"] = workspace_record

    @app.call(env)
  end
end
