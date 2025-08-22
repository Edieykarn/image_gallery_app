class PhotosController < ApplicationController
  before_action :set_gallery
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :full_size]
  before_action :ensure_gallery_owner, except: [:show, :full_size]
  skip_before_action :authenticate_user!, only: [:show, :full_size]

  def show
    redirect_to @gallery
  end

  def full_size
    render layout: false
  end

  def new
    @photo = @gallery.photos.build
  end

  def create
    @photo = @gallery.photos.build(photo_params)
    
    if @photo.save
      redirect_to @gallery, notice: 'Photo uploaded successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      redirect_to @gallery, notice: 'Photo updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    redirect_to @gallery, notice: 'Photo deleted successfully!'
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:gallery_id]) if params[:gallery_id]
    @gallery ||= @photo.gallery if @photo
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :image)
  end

  def ensure_gallery_owner
    unless @gallery.user == current_user
      redirect_to @gallery, alert: 'Access denied. You can only manage photos in your own galleries.'
    end
  end
end
