require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', 
                           first_name: 'Vivian', last_name: 'Kim') }
  let(:gallery) { Gallery.create!(title: 'Test Gallery', user: user) }

  describe 'validations' do
    it 'is invalid without a gallery' do
      photo = Photo.new
      expect(photo).to_not be_valid
      expect(photo.errors[:gallery]).to include("can't be blank")
    end

    it 'is invalid without an attached image' do
      photo = Photo.new(gallery: gallery)
      expect(photo).to_not be_valid
      expect(photo.errors[:image]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to gallery' do
      association = Photo.reflect_on_association(:gallery)
      expect(association.macro).to eq :belongs_to
    end

    it 'has one user through gallery' do
      association = Photo.reflect_on_association(:user)
      expect(association.macro).to eq :has_one
      expect(association.options[:through]).to eq :gallery
    end

    it 'has one attached image' do
      expect(Photo.new).to respond_to(:image)
    end
  end

  describe 'scopes' do
    before do
      @photo1 = Photo.new(gallery: gallery)
      @photo1.image.attach(io: StringIO.new("test"), filename: "test1.jpg", content_type: "image/jpeg")
      @photo1.save!
      
      @photo2 = Photo.new(gallery: gallery)
      @photo2.image.attach(io: StringIO.new("test"), filename: "test2.jpg", content_type: "image/jpeg")
      @photo2.save!
      
      @photo3 = Photo.new(gallery: gallery)
      @photo3.image.attach(io: StringIO.new("test"), filename: "test3.jpg", content_type: "image/jpeg")
      @photo3.save!
    end

    describe '.ordered' do
      it 'returns photos ordered by id' do
        expect(Photo.ordered).to eq [@photo1, @photo2, @photo3]
      end
    end

    describe '.recent' do
      it 'returns photos ordered by created_at desc' do
        expect(Photo.recent.first).to eq @photo3
      end
    end
  end

  describe 'methods' do
    let(:photo) do
      p = Photo.new(gallery: gallery)
      p.image.attach(io: StringIO.new("test"), filename: "test.jpg", content_type: "image/jpeg")
      p.save!
      p
    end

    describe '#thumbnail' do
      it 'returns nil when no image is attached' do
        photo.image.purge
        expect(photo.thumbnail).to be_nil
      end

      it 'returns a variant when image is attached' do
        expect(photo.thumbnail).to be_present
      end
    end

    describe '#display_image' do
      it 'returns nil when no image is attached' do
        photo.image.purge
        expect(photo.display_image).to be_nil
      end

      it 'returns a variant when image is attached' do
        expect(photo.display_image).to be_present
      end
    end

    describe 'navigation methods' do
      before do
        @photo1 = Photo.new(gallery: gallery)
        @photo1.image.attach(io: StringIO.new("test"), filename: "test1.jpg", content_type: "image/jpeg")
        @photo1.save!
        
        @photo2 = Photo.new(gallery: gallery)
        @photo2.image.attach(io: StringIO.new("test"), filename: "test2.jpg", content_type: "image/jpeg")
        @photo2.save!
        
        @photo3 = Photo.new(gallery: gallery)
        @photo3.image.attach(io: StringIO.new("test"), filename: "test3.jpg", content_type: "image/jpeg")
        @photo3.save!
      end

      describe '#next_photo' do
        it 'returns the next photo in the gallery' do
          expect(@photo1.next_photo).to eq @photo2
          expect(@photo2.next_photo).to eq @photo3
        end

        it 'returns nil for the last photo' do
          expect(@photo3.next_photo).to be_nil
        end
      end

      describe '#previous_photo' do
        it 'returns the previous photo in the gallery' do
          expect(@photo3.previous_photo).to eq @photo2
          expect(@photo2.previous_photo).to eq @photo1
        end

        it 'returns nil for the first photo' do
          expect(@photo1.previous_photo).to be_nil
        end
      end
    end
  end
end
