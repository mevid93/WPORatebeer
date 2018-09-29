require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create(:user)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      visit signin_path
      sign_in(username: "Pekka", password: "Foobar1")
      expect(page).to have_content "Welcome back!"
      expect(page).to have_content "Pekka"
    end

    it "is redirected back to signin form if wrong credentials given" do
      visit signin_path
      sign_in(username: "Pekka", password: "Wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in("user_username", with: "Brian")
    fill_in("user_password", with: "Secret55")
    fill_in("user_password_confirmation", with:"Secret55")
    expect{
        click_button("Create User")
    }.to change{User.count}.by(1)
  end
end

describe "Users page" do
  before :each do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user, username: "Toinen", password: "Toinen1", password_confirmation:"Toinen1")
    @beer = FactoryBot.create(:beer, name: "Testiolut")
    @beer2 = FactoryBot.create(:beer, name: "NoNoNoBeer")
    set_many_ratings_for_beer({user: @user, beer: @beer}, 23, 2)
    set_many_ratings_for_beer({user: @user2, beer: @beer2}, 34, 42)
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "lists ratings done by user" do
    visit user_path(@user)
    expect(page).to have_content("Pekka")
    expect(page).to have_content("Has #{@user.ratings.count} ratings")
    expect(page).to have_content("Testiolut")
    expect(page).not_to have_content("NoNoNoBeer")
  end
end