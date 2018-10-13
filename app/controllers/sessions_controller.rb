class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    # tarkistetaan että käyttäjä on olemassa, ja että salansana on oikea ja ettei käyttäjää ole suljettu
    if user&.authenticate(params[:password]) && !user&.closed?
      session[:user_id] = user.id
      # uudelleen ohjataan käyttäjä omalle sivulleen
      redirect_to user, notice: "Welcome back!"
    elsif user&.authenticate(params[:password]) && user&.closed?
      redirect_to signin_path, notice: "your account is closed, please contact admin"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
