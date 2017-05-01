require "test_helper"

describe User do
  describe "User creation" do

    it "doesn't allow a user without a username" do
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :username
    end

    it "doesn't allow two users with the same username" do
      one = users(:one)
      duplicate = User.new(username: one.username, email: "sandwich@gmail.com")

      duplicate.valid?.must_equal false
    end

    it "doesn't allow a user without an email" do
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :username
    end

    it "doesn't allow two users with the same email" do
      one = users(:one)
      duplicate = User.new(username: "Sandwich", email: one.email)
      duplicate.valid?.must_equal false
    end

    it "sets the username as email when the username is not given" do
      auth_hash = {
        "provider" => "github",
        "uid" => 666,
        "info" => { "email" => "bob@bob.com", "name" => "" }
      }
      user = User.create_from_github(auth_hash)

      user.username.must_equal user.email
    end

    it "sets the image url as default when image is not given" do
      auth_hash = {
        "provider" => "github",
        "uid" => 666,
        "info" => { "email" => "bob@bob.com", "name" => "" }
      }
      user = User.create_from_github(auth_hash)

      user.image_url.must_equal 'default-user-image.png'
    end
  end

  describe "instance methods" do
    let(:user_without_sales) { User.new(username: "noob", email: "noob@coding.com") }

    describe "User#order_count" do
      it "returns the number of orders to be fulfilled by a user" do
        users(:one).order_count.must_equal 4
      end

      it "returns zero for a user without orders to fulfill" do
        user_without_sales.order_count.must_equal 0
      end
    end

    describe "User#total_revenue" do
      it "returns the total revenue from all orders" do
        users(:one_sale_fred).products << products(:kidjams)
        expected_revenue = products(:kidjams).price * order_items(:one).quantity

        users(:one_sale_fred).total_revenue.must_equal expected_revenue
      end

      it "returns 0 if a user has no sales" do
        user_without_sales.total_revenue.must_equal 0
      end
    end

    describe "User#order_count_by_status" do
      it "returns the order count given an order status" do
        users(:one_sale_fred).order_count_by_status("paid").must_equal 1
      end

      it "returns 0 if a user doesn't have an order in a given status" do
        users(:one_sale_fred).order_count_by_status("pending").must_equal 0
      end
    end

    describe "User#revenue_by_order_status" do
      it "returns the user's revenue for all orderitems in a given order status" do
        expected_revenue = products(:kidjams).price * order_items(:one).quantity
        users(:one_sale_fred).revenue_by_order_status("paid").must_equal expected_revenue
      end

      it "returns the expected revenue when a user has multiple orders in a given status" do
        order = orders(:one).clone
        OrderItem.create(
          product: products(:kidjams),
          order: order,
          quantity: 2,
          status: "paid"
        )

        total_sold_quantity = order_items(:one).quantity + 2
        expected_revenue = products(:kidjams).price * total_sold_quantity
        users(:one_sale_fred).revenue_by_order_status("paid").must_equal expected_revenue
      end

      it "returns 0 when a user has no sales" do
        user_without_sales.revenue_by_order_status("paid").must_equal 0
      end
    end

  end

end
