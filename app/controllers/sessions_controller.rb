class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(provider: 'github', uid: auth_hash[:uid])

    if user.nil?
      user = User.create_from_github(auth_hash)

      if user.nil?
        flash.now[:failure] = "Could not log in"
        redirect_to root_path
      end
    end

    session[:user_id] = user.id
    flash[:success] = "Successfully logged in as #{user.username}!"
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

end
