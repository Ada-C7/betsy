class OrdersController < ApplicationController
    before_action :initialize_cart, only: [:show, :edit, :update, :confirm]

    def index
        unless Product.find_by(user_id: params[:user_id]).nil?
            if params[:status]
                @orders = Order.includes(:product_orders).where(product_orders: { product_id: Product.where(user_id: params[:user_id]).ids }).where(status: params[:status])
                @status_revenue = revenue_by_status(@orders, params[:user_id])
            else
                @orders = Order.includes(:product_orders).where(product_orders: { product_id: Product.where(user_id: params[:user_id]).ids })
                @status_revenue = revenue_by_status(@orders, params[:user_id])
            end
        end
    end

    def create
        Order.create(order_params)

        redirect_to orders_path
    end

    def new
        @order = Order.new
    end

    def show
        @order = @cart # from initialize_cart method in ApplicationController
        @sum = @cart.cart_total
        @items = @cart.cart_quantity
    end

    # At cart checkout
    def edit
        @order = @cart
    end

    def update
        @order = @cart
        @order.update(order_params)
        @order.status = 'paid'
        # if order (cart) is successfully saved as paid go to confirmation
        if @order.save
            flash[:result_text] = "Your Order # #{@order.id} has been placed!"

            @order.products.each do |product|
                product.stock -= ProductOrder.find_by(order_id: @order.id, product_id: product.id).quantity
                product.save
            end

            redirect_to confirmation_path
        else
            flash[:result_text] = 'Unable to place your order.'
            @order.status = 'pending'
            render 'edit'
        end
    end

    # Buyer removes item in cart from Product#Show page
    def remove_product
        old_line_item = ProductOrder.find_by_id(params[:item_id].to_i)
        old_line_item.destroy!

        redirct_to order_path
    end

    # Order status updated by Seller
    def update_status
        @order = Order.find_by(id: params[:order_id])
        @order.status = params[:status]
        @order.save
        flash[:result_text] = "Successfluffy updated Order # #{@order.id} to #{@order.status}"
        redirect_to :back
    end

    # Checkout confirmation page
    def confirm
        @order = @cart
        @sum = @cart.cart_total
        @items = @cart.cart_quantity
        session[:order_id] = nil if @order.status == 'paid'
    end

    # Buyer adds to cart from Product#Show page
    def add_product
        prev_item = ProductOrder.find_by(product_id: product_params[:product_id], order_id: product_params[:order_id])
        product = Product.find_by(id: product_params[:product_id])
        if prev_item && !(product_params[:quantity].to_i > (product.stock - prev_item.quantity))
            flash[:result_text] = "Added #{product_params[:quantity]} more #{product.name} to cart"
            prev_item.quantity += product_params[:quantity].to_i
            prev_item.save!
            redirect_to product_path(prev_item.product_id)
        elsif prev_item && product_params[:quantity].to_i > (product.stock - prev_item.quantity)
            flash[:result_text] = "Can't add more items than are available!"
            redirect_to product_path(prev_item.product_id)
        else
            flash[:result_text] = "Successfluffy added #{product.name} to cart"
            ProductOrder.create!(product_params)
            redirect_to order_path
        end
    end

    # Buyer adds/subtracts items from Order#Show page
    def update_quantity
        line_item = ProductOrder.find_by_id(params[:item_id].to_i)
        line_item.quantity = params[:quantity].to_i

        # removes product from cart when qty is updated to 0

        if line_item.quantity == 0
            line_item.destroy!
        else
            line_item.save!
        end
        redirect_to order_path
    end

    def revenue_by_status(orders, user)
        sum = 0.00
        orders.each do |order|
            order.product_orders.each do |item|
                product = Product.find_by(id: item.product_id, user_id: user)
                sum += product.price * item.quantity
            end
        end
        sprintf('%.2f', sum)
    end

    # ~~~~~~~~~~~~~~~~~~~~~~~~ooooooooooooooooooooooo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    private

    def order_params
        params.require(:order).permit(:status, :email_address, :mailing_address, :card_name, :card_expiration, :card_cvv, :credit_card, :zipcode)
    end

    def product_params
        params.permit(:product_id, :quantity, :order_id)
    end
end
