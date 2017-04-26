class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_by(provider: 'github', uid: auth_hash[:uid])

    if user.nil?
      new_user = true
      user = User.create_from_github(auth_hash)

      if user.nil?
        flash[:status] = "failure"
        flash[:result_text] = "Login Failed"
        return redirect_to root_path
      end
    else
      new_user = false
    end

    session[:user_id] = user.id
    flash[:status] = "success"
    flash[:result_text] = "Successfully logged in through Github!"
    redirect_to new_user ? edit_account_path : root_path
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

end
