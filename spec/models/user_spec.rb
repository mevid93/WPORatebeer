require 'rails_helper'

RSpec.describe User, type: :model do

  it "has the username set correctly" do
    user = User.new username: "Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without password" do
    user = User.create username: "Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }
    let(:test_brewery){ Brewery.new name:"test", year:2000 }
    let(:test_beer){ Beer.create name:"testbeer", style:"teststyle", brewery:test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved when password is too short" do
    user = User.create username: "Pekka", password: "Se1", password_confirmation:"Se1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved when password contains only letters" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite beer style" do
    let(:user){ FactoryBot.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one style with highest average rating if several rated" do
      create_styled_beers_with_many_ratings({ user: user }, "Style1", 1, 2, 3, 4)
      create_styled_beers_with_many_ratings({ user: user }, "Style2", 10, 2, 13, 4)
      style = "WinningStyle"
      create_styled_beers_with_many_ratings({ user: user }, style, 11, 12, 13, 14)
      expect(user.favorite_style).to eq(style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
      brewery = FactoryBot.create(:brewery)
      beer = FactoryBot.create(:beer, brewery: brewery)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one brewery with highest average rating if several rated" do
      brewery1 = FactoryBot.create(:brewery, name: "Testi1")
      brewery2 = FactoryBot.create(:brewery, name: "Testi2")
      create_brewery_beers_with_many_ratings({user: user, brewery: brewery1}, 1, 2, 5, 10)
      create_brewery_beers_with_many_ratings({user: user, brewery: brewery2}, 34, 23, 5, 10)
      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings( object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_styled_beer_with_rating(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_styled_beers_with_many_ratings( object, style, *scores)
  scores.each do |score|
    create_styled_beer_with_rating(object, style, score)
  end
end

def create_brewery_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer, brewery: object[:brewery])
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_brewery_beers_with_many_ratings( object, *scores)
  scores.each do |score|
    create_brewery_beer_with_rating(object, score)
  end
end