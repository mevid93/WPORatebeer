require 'rails_helper'

include Helpers

describe "Beer" do
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    @brewery = FactoryBot.create(:brewery)
  end

  it "should be created when name is valid" do
    visit new_beer_path
    fill_in("beer_name", with: "Testiolut")
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(@brewery.beers.count).to eq(1)
  end

  it "should not be created when name is not valid" do
    visit new_beer_path
    fill_in("beer_name", with: "")
    click_button "Create Beer" 
    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end