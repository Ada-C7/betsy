class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash['uid']
      user = User.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
      if user.nil?
        user = User.create_from_github(auth_hash)
        if user.nil?
          flash[:error] = "Could not log in"
        else
          session[:user_id] = user.id
        end
      else
        session[:user_id] = user.id
        # if there's a pending order in the cart when someone logs in
        # we want to merge the cart with any previous pending order that user had saved and not finished
        if session[:order_id]
          # save the in progress order
          in_progress_order = Order.find(session[:order_id])
          # find the old pending order for the current user
          pending_order = Order.find_by(status: "pending", email: current_user.email)
          if pending_order
          # reset the session order id to the pending order
            session[:order_id] = pending_order.id
            # move anything in in progress order to the pending order
            pending_order.merge_pending_orders(in_progress_order)
          end
        else # no current order_id
          # find any pending orders for the newly logged in user
          pending_order = Order.find_by(status: "pending", email: current_user.email)
          if pending_order
            # and set the session order id to that order (no merging happening)
            session[:order_id] = pending_order.id
          end
        end
      end
    else
      flash[:error] = 'Could not log in'
    end
    redirect_to :root
  end

  # don't think we need this??
  # def index
  #   @user = User.find(session[:user_id])
  # end

  def logout
    if session[:order_id]
      order = Order.find(session[:order_id])
      order.email = current_user.email
      order.save
    end
    session[:user_id] = nil
    session[:order_id] = nil
    flash[:success] = "You are successfully logged out"
    redirect_to root_path
  end

end
