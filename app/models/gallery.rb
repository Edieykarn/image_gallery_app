class Gallery < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_one_attached :cover_image
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :user, presence: true
  
  enum :status, { draft: 0, published: 1, personal: 2 }
  
  scope :published_galleries, -> { where(status: :published).includes(:photos, :user) }
  scope :recent, -> { order(created_at: :desc) }
  
  def cover_photo
    cover_image.attached? ? cover_image : photos.first&.image
  end

  def can_be_viewed_by?(user)
    published? || (user && user == self.user)
  end
end
