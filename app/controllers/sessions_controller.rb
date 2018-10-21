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

  def create_oauth
    nickname = request.env['omniauth.auth'].info.nickname
    user = User.find_by(username: nickname)
    if user.nil?
      # käyttäjää ei ollut vielä olemassa, joten luodaan se
      # generoidaan käyttäjälle satunnainen salasana
      password = (0...8).map { rand(65..91).chr }.join
      password += rand(1000).to_s
      user = User.create(username: nickname, password: password, password_confirmation: password)
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome!"
    elsif user&.closed?
      redirect_to signin_path, notice: "your account is closed, please contact admin"
    else
      # uudelleen ohjataan käyttäjä omalle sivulleen
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end
end
