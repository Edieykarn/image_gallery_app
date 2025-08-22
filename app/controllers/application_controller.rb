class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:index, :show]

  protected

  def ensure_gallery_owner
    unless @gallery.user == current_user
      redirect_to galleries_path, alert: 'Access denied. You can only manage your own galleries.'
    end
  end
end
