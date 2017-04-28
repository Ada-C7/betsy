require "test_helper"

describe User do
  let(:user) { User.new }

  it "can create a new user" do
    user = User.new(username: "louise", email: "louise@test.com", uid: "11223", provider: "github")
    user.save.must_equal true
  end

  # requires a username
  it "must have a username" do
    user = User.new(email: "louise@test.com")
    user.save.must_equal false
  end

  # username is unique
  it "username must be unique" do
    user = User.new(email: "test@test.com", username: "auroralemieux")
    user.save.must_equal false
  end

  # requires an email
  it "must have an email" do
    user = User.new(username: "auro")
    user.save.must_equal false
  end

  # email is unique
  it "email must be unique" do
    user = User.new(username: "pinky", email: "aurora@test.com")
    user.save.must_equal false
  end

  # has many products
  it "has many products" do
    user = users(:aurora)
    user_products = user.products
    user_products.each do |product|
      product.must_be_kind_of Product
    end
  end

  describe "#Orders" do
    it "returns a list of past orders" do
      user = users(:aurora)
      orders = user.orders
      orders.each do |order|
        order.must_be_instance_of Order
      end
    end

    it "If user has no past orders, returns empty array" do
      user = users(:felix)
      orders = user.orders
      orders.must_equal []
    end
  end

  # describe "Create from github" do
  #   it "Creates a new user when signing in for the first time using github" do
  #
  #
  #   end
  # end

  describe "merchant user orders" do
    describe "user_orders" do
      it "shows the logged in user's list of all non-pending orders tied to their products" do
        user = users(:user_orders_test_user_one)
        user_one_orders = user.user_orders
        user_one_orders.length.must_equal 5
      end
    end

    describe "user_orders_items" do
      it "shows all non-pending orders_items tied to user's products" do
        user = users(:user_orders_test_user_one)
        user_one_orders_items = user.user_orders_items

        user_one_orders_items.length.must_equal 5
      end
      it "returns empty array if user has no order_items" do
        user = users(:no_products_user)
        jackie_order_items = user.user_orders_items

        jackie_order_items.length.must_equal 0
        jackie_order_items.must_equal []
      end
    end


    describe "user_status_orders('complete')" do
      it "returns array of only completed orders" do
        user = users(:user_orders_test_user_one)
        user_one_status_orders = user.user_status_orders("complete")

        user_one_status_orders.must_be_kind_of Array
        user_one_status_orders.length.must_equal 3

        user_one_status_orders[0].must_be_instance_of Order

        user_one_status_orders[0].status.must_equal "complete"
        user_one_status_orders[1].status.must_equal "complete"
        user_one_status_orders[2].status.must_equal "complete"
      end

      it "returns empty array if there are no complete orders" do
        user = users(:no_products_user)
        user_one_status_orders = user.user_status_orders("complete")
        user_one_status_orders.must_be_kind_of Array
        user_one_status_orders.length.must_equal 0
      end

      it "returns array of only paid orders" do
        user = users(:user_orders_test_user_one)
        user_one_status_orders = user.user_status_orders("paid")

        user_one_status_orders.must_be_kind_of Array
        user_one_status_orders.length.must_equal 2

        user_one_status_orders[0].must_be_instance_of Order

        user_one_status_orders[0].status.must_equal "paid"
        user_one_status_orders[1].status.must_equal "paid"
      end


    end

    describe "user_total" do
      it "shows grand total of products sold by user" do
        user = users(:user_orders_test_user_one)
        user_one_total = user.user_total

        user_one_total.must_equal 347
      end

      it "shows grand total as zero if user has no sold products" do
        user = users(:no_products_user)
        jackie_total = user.user_total

        jackie_total.must_equal 0
      end
    end

    describe "user_status_total" do
      it "shows total of products according to shipped" do
        user = users(:user_orders_test_user_one)
        user_one_total = user.user_status_total(true)

        user_one_total.must_equal 265
      end

      #this is failing...check to see which orders are pending
      it "shows total of products according to not shipped" do
        user = users(:user_orders_test_user_one)
        user_one_total = user.user_status_total(false)

        user_one_total.must_equal 82
      end

      it "returns zero if user has no orders_items" do
        user = users(:no_products_user)
        no_products_user_total = user.user_status_total(false)

        no_products_user_total.must_equal 0
      end
    end

    describe "user_purchases_total" do
      it "shows total of all non-pending products purchased by user" do
        user = users(:user_orders_test_user_one)
        user_one_purchases = user.user_purchases_total

        user_one_purchases.must_equal 100513.99

      end

      it "returns zero total if no purchased products" do
        user = users(:no_products_user)
        no_purchase_user_total = user.user_purchases_total

        no_purchase_user_total.must_equal 0
      end
    end
  end
end
