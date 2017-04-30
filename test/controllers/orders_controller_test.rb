require "test_helper"

describe OrdersController do

  describe "index" do
    it "should get index" do
      get carts_path
      must_respond_with :success
    end

    it "should get cart with items" do
      product = products(:famjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      get carts_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should get show" do
      get order_path(orders(:one).id)
      must_respond_with :success
    end

    it "should show 404 when order not found" do
      get order_path("stupid")
      must_respond_with :missing
    end
  end

  describe "confirmation" do
    it "should get confirmation" do
      get confirmation_path(orders(:three).id)
      must_respond_with :success
    end

    it "should show 404 when order not found" do
      get confirmation_path("stupid")
      must_respond_with :missing
    end
  end

  describe "set" do
    it "should set a product in cart" do
      product = products(:famjams)
      post set_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path
    end

    it "can change item quantity in cart" do
      product = products(:jamjams)
      post set_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path

      # maybe check the quantity is two and not three?
      product = products(:jamjams)
      post set_item_path, params: { id: product.id, quantity: 2 }
      must_redirect_to carts_path
    end


    it "cannot add product if not enough in stock" do
      product = products(:jamjams)
      post set_item_path, params: { id: product.id, quantity: 40 }

      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Could not add due to insufficient stock."
      must_redirect_to product_path(product.id)
    end

    it "cannot update existing item quantity in cart if not enough stock" do
      product = products(:famjams)
      post set_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path

      post set_item_path, params: { id: product.id, quantity: 51 }
      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Could not add due to insufficient stock."
      must_redirect_to carts_path
    end
  end

  describe "add" do
    it "should add new product to cart" do
      product = products(:famjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path
    end

    it "can add item to existing item in cart" do
      product = products(:jamjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path

      product = products(:jamjams)
      post add_item_path, params: { id: product.id, quantity: 2 }
      must_redirect_to carts_path
    end

    it "cannot add product if not enough in stock" do
      product = products(:jamjams)
      post add_item_path, params: { id: product.id, quantity: 40 }

      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Could not add due to insufficient stock."
      must_redirect_to product_path(product.id)
    end

    it "cannot add more items to existing items if not enough stock" do
      product = products(:jamjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      must_redirect_to carts_path

      post add_item_path, params: { id: product.id, quantity: 30 }
      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Could not add due to insufficient stock."
      must_redirect_to product_path(product.id)
    end
  end

  describe "User is Logged in" do
    before do
      login(users(:one))
    end

    describe "shipped" do
      it "marks order item shipped" do
        patch shipped_path(order_items(:one).id)

        flash[:status].must_equal :success
        flash[:result_text].must_equal "Order item was shipped"
        must_respond_with :redirect
      end

      it "responds with bad request and doesn't update the DB if bad item" do
        patch shipped_path(order_items(:missing_quantity).id)

        flash[:status].must_equal :failure
        flash[:result_text].must_equal "Could not ship item"
        must_respond_with :bad_request
      end
    end

    describe "cancelled" do
      it "marks order item cancelled" do
        patch cancelled_path(order_items(:one).id)

        flash[:status].must_equal :success
        flash[:result_text].must_equal "Order item was cancelled"
        must_respond_with :redirect
      end

      it "responds with bad request and doesn't update the DB if bad item" do
        patch cancelled_path(order_items(:missing_product).id)

        flash[:status].must_equal :failure
        flash[:result_text].must_equal "Could not cancel item"
        must_respond_with :bad_request
      end
    end

    describe "complete order" do
      it "marks order complete if all order items are shipped" do
        patch shipped_path(order_items(:five).id)

        must_respond_with :redirect
        must_redirect_to account_orders_path
        flash[:status] = :success
        flash[:result_text].must_equal "Order was completed"
      end

      it "marks order complete if all order items are cancelled and at least one is shipped" do
        patch shipped_path(order_items(:four).id)
        patch cancelled_path(order_items(:six).id)

        must_respond_with :redirect
        must_redirect_to account_orders_path
        flash[:status] = :success
        flash[:result_text].must_equal "Order was completed"
      end

      it "marks order cancelled if all items cancelled" do
        patch cancelled_path(order_items(:five).id)

        must_respond_with :redirect
        must_redirect_to account_orders_path
        flash[:status] = :success
        flash[:result_text].must_equal "Order was cancelled"
      end

      it "order status unchanged if any items are paid" do
        patch shipped_path(order_items(:four).id)

        order_items(:four).order.status.must_equal "paid"
        must_respond_with :redirect
        must_redirect_to account_orders_path
      end
    end
  end

  describe "User is not Logged in" do
    describe "shipped" do
      it "cannot mark items shipped" do
        patch shipped_path(order_items(:one).id)

        flash[:status].must_equal "warning"
        flash[:result_text].must_equal "You must be logged in to view this page."
        must_respond_with :bad_request
      end
    end

    describe "cancelled" do
      it "cannot mark items cancelled" do
        patch cancelled_path(order_items(:one).id)

        flash[:status].must_equal "warning"
        flash[:result_text].must_equal "You must be logged in to view this page."
        must_respond_with :bad_request
      end
    end

    describe "cannot complete order" do
      it "marks order complete if all order items are shipped" do
        patch shipped_path(order_items(:five).id)

        flash[:status].must_equal "warning"
        flash[:result_text].must_equal "You must be logged in to view this page."
        must_respond_with :bad_request
      end
    end
  end

  describe "edit" do
    it "should get edit when there is an order" do
      product = products(:kidjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      get checkout_path
      must_respond_with :success
    end

    it "should redirect when order not found" do
      get checkout_path
      must_respond_with :redirect
      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Cannot check out if your cart is empty"
    end

    it "should not allow puchase when someone already bought the item" do
      product = products(:jamjams)
      post add_item_path, params: { id: product.id, quantity: 2 }
      product_sold = Product.find_by_id(products(:jamjams).id)
      product_sold.quantity = 1
      product_sold.save
      get checkout_path
      flash[:status].must_equal :failure
      flash[:result_text].must_equal "Oops, someone must have purchased this item."
    end
  end

  describe "update" do
    it


  end

  describe "destroy" do
    it "should delete an item from the cart" do
      product = products(:kidjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      delete order_path(product.id)
      must_redirect_to carts_path
    end
  end
end
