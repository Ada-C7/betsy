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
      get order_path("no order")
      must_respond_with :missing
    end
  end

  describe "confirmation" do
    it "should get confirmation" do
      get confirmation_path(orders(:three).id)
      must_respond_with :success
    end

    it "should show 404 when order not found" do
      get confirmation_path("no order")
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

  describe "shipped" do
    # patch shipped_path(order_items(:one).id)
    # respond_with :redirect
  end

  describe "cancelled" do

  end

  describe "complete order" do

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

    # either the method or the test are not working
    # it "should get edit when there is an order" do
    #   product = products(:kidjams)
    #   post add_item_path, params: { id: product.id, quantity: 2 }
    #   product.quantity = 1
    #   get checkout_path
    #   must_respond_with :redirect
    #   flash[:status].must_equal :failure
    #   flash[:result_text].must_equal "Oops, someone must have purchased this item."
    # end
  end

  describe "update" do


  end

  describe "destroy" do
    it "should delete an item from the cart" do
      product = products(:kidjams)
      post add_item_path, params: { id: product.id, quantity: 1 }
      delete order_path(product.id)
      must_redirect_to carts_path
    end
  end

  #
  #   it "should show a 404 when editing a work that doesn't exist" do
  #     get edit_work_path(1)
  #     must_respond_with :missing
  #   end
  #
  #   it "should update a work" do
  #     patch work_path(works(:aja).id), params: { work: {title: "Wooow"} }
  #
  #     work = Work.find(works(:aja).id)
  #
  #     work.title.must_equal "Wooow"
  #   end
  #
  #   it "should redirect to the corresponding list after updating" do
  #     patch work_path(works(:goldman).id), params: { work: {title: "Princess Bride 2"} }
  #
  #     must_respond_with :redirect
  #     must_redirect_to movies_path
  #   end
  #
  #   it "should show a flash if attempting to update work with no title" do
  #     patch work_path(works(:ursula).id), params: { work: { title: ""} }
  #
  #     assert_equal "A problem occurred: Could not update book", flash[:error]
  #   end
  #
  #   it "shouldn't change the database if no title present" do
  #     patch work_path(works(:goldman).id), params: { work: {title: ""} }
  #
  #     work = Work.find(works(:goldman).id)
  #
  #     work.title.must_equal "Princess Bride"
  #   end
  #
  #   it "should show the new work form" do
  #     get new_work_path
  #     must_respond_with :success
  #   end
  #
  #   it "should delete a work and redirect to the corresponding list" do
  #     delete work_path(works(:goldman).id)
  #     must_redirect_to movies_path
  #   end
end
