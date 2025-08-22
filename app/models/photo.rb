class Photo < ApplicationRecord
  belongs_to :gallery
  has_one_attached :image
  has_one_attached :thumbnail
  
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :image, presence: true
  validates :gallery, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  
  after_commit :generate_thumbnail, on: [:create, :update], if: :image_attached?

  private

  def image_attached?
    image.attached? && image.blob.persisted?
  end

  def generate_thumbnail
    return unless image.attached?

    thumbnail.attach(
      io: StringIO.new(image.variant(resize_to_limit: [400, 400]).processed.download),
      filename: "thumb_#{image.filename}",
      content_type: image.content_type
    )
  end
end