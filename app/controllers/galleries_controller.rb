class GalleriesController < ApplicationController
  before_action :set_gallery, only: [:show, :edit, :update, :destroy, :slideshow]
  before_action :ensure_gallery_owner, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show, :slideshow]

  def index
    @galleries = Gallery.published_galleries.recent.includes(:photos, :user)
  end

  def show
    unless @gallery.can_be_viewed_by?(current_user)
      redirect_to galleries_path, alert: 'Gallery not found or access denied.'
      return
    end
    
    @photos = @gallery.photos.includes(image_attachment: :blob).recent
  end

  def slideshow
    unless @gallery.can_be_viewed_by?(current_user)
      redirect_to galleries_path, alert: 'Gallery not found or access denied.'
      return
    end
    
    @photos = @gallery.photos.includes(image_attachment: :blob)
    render layout: 'slideshow'
  end

  def new
    @gallery = current_user.galleries.build
  end

  def create
    @gallery = current_user.galleries.build(gallery_params)
    
    if @gallery.save
      redirect_to @gallery, notice: 'Gallery created successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @gallery.update(gallery_params)
      redirect_to @gallery, notice: 'Gallery updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @gallery.destroy
    redirect_to galleries_path, notice: 'Gallery deleted successfully!'
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

  def gallery_params
    params.require(:gallery).permit(:title, :description, :status, :cover_image)
  end

  def ensure_gallery_owner
    unless @gallery.user == current_user
      redirect_to galleries_path, alert: 'Access denied. You can only manage your own galleries.'
    end
  end
end

