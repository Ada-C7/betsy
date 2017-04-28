class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #these will run before all actions
  before_action :setup_session_and_cart
  before_action :require_login

  #setting these up as helpers means we can access them from other places in the app (like in other controllers and in views)
  helper_method :current_merchant
  helper_method :current_order
  helper_method :user_matches_merchant
  helper_method :category_names


  #upon starting the browser, set up a new order with and order id and also set up a guest for session
  #store the order and guest info in the session hash
  def setup_session_and_cart
    if !session[:merchant_id]
      #check if guest_id is nil b/c otherwise the guest_id and the order_id get reset everytime someone clicks on anything (because it's a before_action for the entire application)
      if session[:guest_id] == nil
        session[:guest_id] = "guest"
        order = Order.create
        session[:order_id] = order.id
      end
    end
  end


#creates an array of 2-element arrays where the first element is the category name and the second is the category id.
#use this array in the form to create a product in a select helper where the names are what shows up in the view and IDs are the values that get passed to the create/update action
def category_names
  names = Category.all.map { |category| [category.name, category.id] }
  return names
end

#checks if there is a merchant logged in using the current_merchant method; flashes and error and redirects if not
def require_login
  if current_merchant.nil?
    flash[:error] = "You must be logged in to do that"
    redirect_to root_path
  end
end

#checks to see if the current_merchant and the merchant showing on the merchant show page match
#if they don't match, flashes an error
def user_matches_merchant
  if current_merchant.id != ( params[:merchant_id] || params[:id] ).to_i
    flash[:error] = "**You do not have permission to view that page**"
    redirect_to :back
  end
end

#gets that 404 message html view
def render_404
  render file: "#{ Rails.root }/public/404.html", status: 404
end

#finds the current merchant using the merchant_id key in session (this is created only when someone logs in)
def current_merchant
  if session[:merchant_id]
    @login_merchant = Merchant.find_by(id: session[:merchant_id])
  end
end

#finds the current_order using the order_id in the session hash
def current_order
  if session[:order_id] != nil
    Order.find_by_id(session[:order_id])
  else
    order = Order.create
    session[:order_id] = order.id
  end
end

end
