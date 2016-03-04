require 'rails_helper'

describe Restaurant, type: :model do

  it { should have_many(:reviews).dependent(:destroy) }

  it 'is not valid with a name of less than 3 characters' do
    restaurant = Restaurant.new(name: "pr")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: "sarah's cafe")
    restaurant = Restaurant.new(name: "sarah's cafe")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'Crisis')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns the rating' do
        restaurant = Restaurant.create(name: 'Crisis')
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        restaurant = Restaurant.create(name: 'Crisis')
        p restaurant.reviews.create(rating: 1)
        review_two = restaurant.reviews.new(rating: 5)
        review_two.save(validate: false)
        expect(restaurant.average_rating).to eq 3
      end
    end
  end
end
