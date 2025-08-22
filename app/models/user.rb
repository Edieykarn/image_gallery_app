class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :galleries, dependent: :destroy
  has_many :photos, through: :galleries

  validates :email, presence: true, uniqueness: true

  def display_name
    email.split('@').first.capitalize
  end
end
