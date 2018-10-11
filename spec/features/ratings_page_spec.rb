require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from:"rating[beer_id]")
    fill_in("rating[score]", with:"15")
    expect{
        click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)
    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings page" do
  let!(:user) { FactoryBot.create :user }

  it "should not have any before been created" do
    visit ratings_path
    expect(page).to have_content 'Ratings'
    expect(page).to have_content 'Total number of ratings: 0'
  end

  describe "when ratings exists" do
    before :each do
      # jotta muuttuja näkyisi it-lohkossa, tulee sen nimen alkaa @-merkillä
      create_beers_with_many_ratings({user: user}, 1, 34, 22, 33, 23)
      @ratings = Rating.all
    end

    it "lists the breweries and their total number" do
      visit ratings_path
      expect(page).to have_content 'Ratings'
      expect(page).to have_content 'anonymous'
      expect(page).to have_content "Total number of ratings: #{@ratings.count}"
    end
  end
end