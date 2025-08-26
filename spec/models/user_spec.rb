require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123',
        first_name: 'Vivian',
        last_name: 'Kim'
      )
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(first_name: 'Vivian', last_name: 'Kim', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a first name' do
      user = User.new(email: 'test@example.com', last_name: 'Kim', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last name' do
      user = User.new(email: 'test@example.com', first_name: 'Vivian', password: 'password123')
      expect(user).to_not be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid with duplicate email' do
      User.create!(email: 'test@example.com', password: 'password123', 
                   first_name: 'Vivian', last_name: 'Kim')
      user = User.new(email: 'test@example.com', password: 'password123',
                      first_name: 'Jane', last_name: 'Smith')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'has many galleries' do
      association = User.reflect_on_association(:galleries)
      expect(association.macro).to eq :has_many
    end

    it 'has many photos through galleries' do
      association = User.reflect_on_association(:photos)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'methods' do
    let(:user) { User.new(first_name: 'Vivian', last_name: 'Kim') }

    describe '#display_name' do
      it 'returns full name' do
        expect(user.display_name).to eq 'Vivian Kim'
      end
    end

    describe '#initials' do
      it 'returns user initials' do
        expect(user.initials).to eq 'VK'
      end
    end
  end
end