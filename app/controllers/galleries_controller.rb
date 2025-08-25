class GalleriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :slideshow]
  before_action :set_gallery, only: [:show, :edit, :update, :destroy, :slideshow]
  before_action :ensure_gallery_owner, only: [:edit, :update, :destroy]

  def index
    @galleries = Gallery.published_galleries.includes(:user, :photos, photos: { image_attachment: :blob }).recent
  end

  def show
    unless @gallery.can_be_viewed_by?(current_user)
      redirect_to galleries_path, alert: 'Gallery not found or access denied.'
      return
    end
    @photos = @gallery.photos.includes(image_attachment: :blob).ordered
  end

  def slideshow
    unless @gallery.can_be_viewed_by?(current_user)
      redirect_to galleries_path, alert: 'Gallery not found or access denied.'
      return
    end
    @photos = @gallery.photos.includes(image_attachment: :blob).ordered
  end

  def new
    @gallery = current_user.galleries.build
  end

  def create
    @gallery = current_user.galleries.build(gallery_params)
    @gallery.status = 'published' # Default to published so it shows publicly
    
    if @gallery.save
      redirect_to @gallery, notice: 'Gallery created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gallery.update(gallery_params)
      redirect_to @gallery, notice: 'Gallery updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gallery.destroy
    redirect_to galleries_path, notice: 'Gallery deleted successfully!'
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to galleries_path, alert: 'Gallery not found.'
  end

  def gallery_params
    params.require(:gallery).permit(:title, :description, :status)
  end

  def ensure_gallery_owner
    unless @gallery.owner?(current_user)
      redirect_to galleries_path, alert: 'Access denied. You can only manage your own galleries.'
    end
  end
end