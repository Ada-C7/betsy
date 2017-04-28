class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      flash[:status] = :failure
      flash[:result_text] = "Merchant Page Not Found"
      redirect_to merchants_path
    end
  end

  def auth_callback
    auth_hash = request.env['omniauth.auth']
    # raise
    # Attempt to find these credentials in out DB
    merchant = Merchant.find_by(oauth_provider: 'github',
                                oauth_uid: auth_hash["uid"])

    if merchant.nil?
      # Don't know this uder - Build a new merchant
      merchant = Merchant.from_github(auth_hash)
      if merchant.save
        session[:merchant_id] = merchant.id
        flash[:result_text] = "Successfully logged in as new Merchant #{merchant.username}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not log in"
        flash[:messages] = merchant.errors.messages
        # merchant.errors.messages.each do |field, problem|
        #   flash[:field] = problem.join(', ')
        # end
      end

    else
      # Welcome back!
      session[:merchant_id] = merchant.id
      flash[:result_text] = "Welcome back, #{merchant.username}"
    end

    redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:result_text] = "Successfully logged out."
    redirect_to root_path
  end
end
