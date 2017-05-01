class SessionsController < ApplicationController
  def auth_callback
    auth_hash = request.env['omniauth.auth']

    merchant = Merchant.find_by(oauth_provider: params[:provider], oauth_uid: auth_hash["uid"])

    if merchant.nil?
      merchant = Merchant.from_github(auth_hash)
      if merchant.save
        session[:merchant_id] = merchant.id
        flash[:message] = "Successfully logged in as merchant #{merchant.username}"
      else
        flash[:message] = "Could not login"
        merchant.errors.messages.each do |field, problem|
        flash[:field] = problem.join(", ")
        end
      end

    else
      session[:merchant_id] = merchant.id
      flash[:message] = "Successfully logged in as a returning user #{merchant.username}"
    end
    redirect_to root_path
  end

  def logout
   session[:merchant_id] = nil
   flash[:result_text] = "Successfully logged out"
   redirect_to root_path
 end



end
