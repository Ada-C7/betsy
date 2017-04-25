class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      head :not_found
    end
  end

  # def login_form;  end
  #
  # def login
  #   merchant = Merchant.find_by(username: params[:username])
  #   if user
  #     session[:merchant_id] = merchant.id
  #     flash[:success] = "Successfully logged in as existing user #{merchant.username}"
  #     redirect_to root_path
  #   elsif
  #     merchant = Merchant.create(username: params[:username])
  #     session[:merchant_id] = merchant.id
  #     flash[:success] = "Successfully created new user #{merchant.username} with ID #{merchant.id}"
  #     redirect_to root_path
  #   else
  #     if merchant.errors.any?
  #       merchant.errors.each do |column, message|
  #         flash.now[:error] = "Could not log in #{message}"
  #       end
  #       render :login_form
  #     end
  #   end
  # end

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
