# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  

  before_action :authenticate_user!, unless: :public_controller_or_action?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  def public_controller_or_action?
    # Skip authentication for Devise controllers
    return true if devise_controller?
    
    # Skip authentication for specific public actions
    public_routes = {
      'home' => ['index'],
      'galleries' => ['index', 'show', 'slideshow'],
      'photos' => ['show'],
      'errors' => ['not_found', 'internal_server_error']
    }
    
    controller_actions = public_routes[params[:controller]]
    controller_actions&.include?(params[:action])
  end
end