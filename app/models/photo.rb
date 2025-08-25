class Photo < ApplicationRecord
  belongs_to :gallery
  has_one :user, through: :gallery
  has_one_attached :image

  validates :gallery, presence: true
  validates :image, presence: true

  scope :ordered, -> { order(:id) }
  scope :recent, -> { order(created_at: :desc) }

  # Image variants for thumbnails and full display
  def thumbnail
    image.attached? ? image.variant(resize_to_limit: [300, 300]) : nil
  end

  def display_image
    image.attached? ? image.variant(resize_to_limit: [1200, 800]) : nil
  end

  # Navigation
  def next_photo
   gallery.photos.where('id > ?', id).ordered.first
  end

  def previous_photo
    gallery.photos.where('id < ?', id).ordered.last
  end

  private

  def image_attached
    errors.add(:image, "must be attached") unless image.attached?
  end
end

