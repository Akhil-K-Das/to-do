# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  respond_to :json

  def create
    super do |user|
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)[0]

      # Return the token and user details in the response
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      }, status: :created and return
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def respond_with(resource, _opts = {})
    # Use the JWT token from request.env and return it in JSON response
    render json: {
      token: request.env['warden-jwt_auth.token'],
      user: resource
    }, status: :ok
  end

  def respond_to_on_destroy
    # Respond appropriately for sign out
    head :no_content
  end
end
  