class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])

    # if it's not there in the db, then make/save it
    if merchant.nil?

      merchant = Merchant.create_from_github(auth_hash)
      if merchant.nil?
        flash[:error] = "Could not log in"
      else
        session[:merchant_id] = merchant.id
        flash[:success] = "Logged in successfully!"
      end
    else
      session[:merchant_id] = merchant.id
      flash[:success] = "Logged in successfully!"
    end

    redirect_to root_path
  end


  def logout
    #session[:merchant_id] = nil
    session.delete(:merchant_id)
    flash[:success] = "You are successfully logged out."
    redirect_to root_path
  end


end
