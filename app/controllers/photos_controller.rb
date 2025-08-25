# app/controllers/photos_controller.rb
class PhotosController < ApplicationController
  before_action :set_gallery
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_action :ensure_gallery_owner, except: [:show]

  def new
    @photo = @gallery.photos.build
  end

  def create
    @photo = @gallery.photos.build(photo_params)
    @photo.user = current_user

    if @photo.save
      redirect_to @gallery, notice: "Photo uploaded successfully!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @photo.update(photo_params)
      redirect_to [@gallery, @photo], notice: "Photo updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    redirect_to @gallery, notice: "Photo deleted successfully!"
  end

  def show; end

  private

  def set_gallery
    @gallery = Gallery.find(params[:gallery_id])
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image)
  end

  def ensure_gallery_owner
    redirect_to @gallery, alert: "Access denied" unless @gallery.user == current_user
  end
end
