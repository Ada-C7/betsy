class SessionsController < ApplicationController
  before_action :require_login, only: [:logout], raise: false

  def create
    auth_hash = request.env['omniauth.auth']

    vendor = Vendor.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])


    if vendor.nil?

      logger.debug "Trying to create a vendor"
      vendor = Vendor.create_from_github(auth_hash)
      logger.debug "Vendor Created: #{vendor != nil}"

      if vendor.nil?
        flash[:error] = "Could not log you in"
        redirect_back(fallback_location: root_path)
      end
    end

    session[:vendor_id] = vendor.id
    flash[:success] = "Logged in successfully!"
    logger.debug "Session id = #{session[:vendor_id]}"
    redirect_to vendor_account_path
  end

  def logout
    session[:vendor_id] = nil
    flash[:success] = "You are successfully logged out"
    redirect_to root_path
  end


end
