class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :find_user
    before_action :initialize_cart

    private

    def find_user
        @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def users_cart
        @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def initialize_cart
        if session[:order_id]
            @cart = Order.find_by(id: session[:order_id])
        else
            @cart = Order.create!(status: 'pending') # T_T needs default status
            session[:order_id] = @cart.id
        end
        @cart_quantity = @cart.cart_quantity
    end

    def require_login
        find_user
        if @current_user.nil?
            flash[:result_text] = 'You must be logged in to do that!'
            redirect_to root_path
        end
    end
end
