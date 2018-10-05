require 'rails_helper'

describe "Places" do
  it "if one is returned by the api, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name:"Oljenkorsi", id:1)]
    )
    allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return(
      Weather.new()
    )
    visit places_path
    fill_in('city', with:'kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the api, they all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Otaniemi").and_return(
        [Place.new(name:"Fat Lizzard", id:1), Place.new(name:"Smökki", id:2)]
    )
    allow(ApixuApi).to receive(:weather_in).with("Otaniemi").and_return(
      Weather.new()
    )
    visit places_path
    fill_in('city', with:"Otaniemi")
    click_button "Search"
    expect(page).to have_content "Fat Lizzard"
    expect(page).to have_content "Smökki"
  end

  it "if none are returned by the api, correct message is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Espoo").and_return(
        []
    )
    allow(ApixuApi).to receive(:weather_in).with("Espoo").and_return(
      Weather.new()
    )
    visit places_path
    fill_in('city', with:"Espoo")
    click_button "Search"
    expect(page).to have_content "No locations in Espoo"
  end
end