require 'rails_helper'

RSpec.describe Beer, type: :model do
  
  it "is saved when it has valid valid name, style and brewery" do
    testipanimo = Brewery.create name: "Testipanimo", year: 2000
    beer = Beer.create name:"Testiolut", style: "Testityyli", brewery: testipanimo
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  describe "is not saved" do

    it "when it does not have a name" do
      testipanimo = Brewery.create name: "Testipanimo", year: 2000
      beer = Beer.create style: "Testityyli", brewery: testipanimo
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "when it does not have a style" do
      testipanimo = Brewery.create name: "Testipanimo", year: 2000
      beer = Beer.create name: "Testiolut", brewery: testipanimo
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

end
