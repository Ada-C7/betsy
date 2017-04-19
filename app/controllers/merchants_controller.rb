class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(params: id)
  end

  def login_form;  end

  def login
    merchant = Merchant.find_by(username: params[:username])
    if user
      session[:merchant_id] = merchant.id
      flash[:success] = "Successfully logged in as existing user #{merchant.username}"
      redirect_to root_path
    elsif
      merchant = Merchant.create(username: params[:username])
      session[:merchant_id] = merchant.id
      flash[:success] = "Successfully created new user #{merchant.username} with ID #{merchant.id}"
      redirect_to root_path
    else
      if user.errors.any?
        user.errors.each do |column, message|
          flash.now[:error] = "Could not log in #{message}"
        end
        render :login_form
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out."
    redirect_to root_path
  end
end
