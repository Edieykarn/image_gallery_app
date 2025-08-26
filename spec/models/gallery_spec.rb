require 'rails_helper'

RSpec.describe Gallery, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', 
                           first_name: 'Vivian', last_name: 'Kim') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      gallery = Gallery.new(title: 'Test Gallery', description: 'Test description', user: user)
      expect(gallery).to be_valid
    end

    it 'is invalid without a title' do
      gallery = Gallery.new(description: 'Test description', user: user)
      expect(gallery).to_not be_valid
      expect(gallery.errors[:title]).to include("can't be blank")
    end

    it 'is invalid with title too short' do
      gallery = Gallery.new(title: 'ab', user: user)
      expect(gallery).to_not be_valid
      expect(gallery.errors[:title]).to include("is too short (minimum is 3 characters)")
    end

    it 'is invalid with title too long' do
      gallery = Gallery.new(title: 'a' * 101, user: user)
      expect(gallery).to_not be_valid
      expect(gallery.errors[:title]).to include("is too long (maximum is 100 characters)")
    end

    it 'is invalid without a user' do
      gallery = Gallery.new(title: 'Test Gallery', description: 'Test description')
      expect(gallery).to_not be_valid
      expect(gallery.errors[:user]).to include("can't be blank")
    end

    it 'is invalid with description too long' do
      gallery = Gallery.new(title: 'Test Gallery', description: 'a' * 1001, user: user)
      expect(gallery).to_not be_valid
      expect(gallery.errors[:description]).to include("is too long (maximum is 1000 characters)")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = Gallery.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many photos' do
      association = Gallery.reflect_on_association(:photos)
      expect(association.macro).to eq :has_many
    end

    it 'has one attached cover image' do
      expect(Gallery.new).to respond_to(:cover_image)
    end
  end

  describe 'enums' do
    it 'defines status enum correctly' do
      expect(Gallery.statuses).to eq({ 'draft' => 0, 'published' => 1, 'personal' => 2 })
    end
  end

  describe 'methods' do
    let(:gallery) { Gallery.create!(title: 'Test Gallery', user: user) }

    describe '#owner?' do
      it 'returns true for gallery owner' do
        expect(gallery.owner?(user)).to be true
      end

      it 'returns false for different user' do
        other_user = User.create!(email: 'other@example.com', password: 'password123',
                                 first_name: 'Jane', last_name: 'Smith')
        expect(gallery.owner?(other_user)).to be false
      end
    end

    describe '#can_be_viewed_by?' do
      it 'allows owner to view any status gallery' do
        gallery.update!(status: 'draft')
        expect(gallery.can_be_viewed_by?(user)).to be true
      end

      it 'allows anyone to view published gallery' do
        gallery.update!(status: 'published')
        other_user = User.create!(email: 'other@example.com', password: 'password123',
                                 first_name: 'Jane', last_name: 'Smith')
        expect(gallery.can_be_viewed_by?(other_user)).to be true
      end

      it 'does not allow non-owner to view draft gallery' do
        gallery.update!(status: 'draft')
        other_user = User.create!(email: 'other@example.com', password: 'password123',
                                 first_name: 'Jane', last_name: 'Smith')
        expect(gallery.can_be_viewed_by?(other_user)).to be false
      end
    end

    describe '#photo_count' do
      it 'returns correct photo count' do
        expect(gallery.photo_count).to eq 0
      end
    end
  end
end