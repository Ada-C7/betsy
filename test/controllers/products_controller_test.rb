require "test_helper"

describe ProductsController do
  let(:product) { products(:kidjams, :famjams, :jamjams).sample }

  describe "guest users" do

    describe "homepage" do
      it "is successful when there are many products" do
        # destroys invalid fixtures
        Product.all[4..12].each { |prod| prod.destroy }

        Product.count.must_be :>, 0
        get root_path
        must_respond_with :success
      end
      it "successful when there are zero products" do
        OrderItem.destroy_all
        Product.destroy_all
        get root_path
        must_respond_with :success
      end
    end

    describe "browse_products" do
      it "successful when routed through a category" do
        get category_products_path(Category.first)
        must_respond_with :success
      end
      it "successful when routed through a merchant" do
        get user_products_path(users(:one))
        must_respond_with :success
      end
    end

    describe "show" do
      it "finds a product that exists" do
        get product_path(product)
        must_respond_with :success
      end
      it "returns 404 for a product that does not exist" do
        product_id = Product.last.id + 1
        get product_path(product_id)
        must_respond_with :missing
      end
    end

    describe "review" do
      it "creates a new review connected to that product" do
        post review_path(products(:famjams).id), params: { product: products(:famjams), rating: 5, comment: "cool" }
        flash[:result_text].must_equal "Successfully reviewed!"
        must_redirect_to product_path(products(:famjams).id)
      end

      it "adds a new review to the database" do
        proc {
          post review_path(products(:famjams).id), params: { product: products(:famjams), rating: 5, comment: "cool" }
        }.must_change 'Review.count', 1
      end

      it "fails to create a new review if the logged in user owns the product" do
        login(users(:one))
        post review_path(products(:jamjams).id), params: { product: products(:jamjams), rating: 5, comment: "cool" }
        must_respond_with :bad_request
        flash[:result_text] = "You cannot review your own product"
      end

      it "does not add a new review to the database" do
        proc {
          login(users(:one))
          post review_path(products(:jamjams).id), params: { product: products(:jamjams), rating: 5, comment: "cool" }
        }.must_change 'Review.count', 0
      end

      it "fails to create a new review if no rating provided" do
        post review_path(products(:jamjams).id), params: { product: products(:jamjams), comment: "cool" }
        must_respond_with :bad_request
        flash[:result_text] = "Could not review"
      end

      it "does not add a new review to the database" do
        proc {
          post review_path(products(:jamjams).id), params: { product: products(:jamjams), comment: "cool" }
        }.must_change 'Review.count', 0
      end
    end
  end

  describe "logged in users" do
    before do
      login(users(:one))
    end

    describe "new" do
      it "runs successfully" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new product" do
        post products_path, params: { product: { user_id: users(:one).id, name: "jammies", quantity: 10, price: 5.0, description: "so cozy", image_url: "jams.jpg" } }
        must_redirect_to root_path
      end
      it "adds a new product to the database" do
        proc {
          post products_path, params: { product: { user_id: users(:one).id, name: "jammies", quantity: 10, price: 5.0, description: "so cozy", image_url: "jams.jpg" } }
        }.must_change 'Product.count', 1
      end
      it "returns 404 and fails to create a new product w invalid data" do
        post products_path, params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
        must_respond_with :bad_request
      end
      it "does not add a new product to the database" do
        proc {
          post products_path, params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
        }.must_change 'Product.count', 0
      end
    end

    describe "edit" do
      it "finds a product that exists" do
        get edit_product_path(product)
        must_respond_with :success
      end
      it "returns 404 for a product that does not exist" do
        product_id = Product.last.id + 1
        get product_path(product_id)
        must_respond_with :missing
      end
    end

    describe "update" do
      it "updates the product" do
        patch product_path(product), params: { product: { name: "jammies", quantity: 10, price: 5.0, description: "so cozy", image_url: "jams.jpg" } }
        must_redirect_to root_path
      end
      it "returns bad_request and fails to update product w invalid data" do
        patch product_path(product), params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
        must_respond_with :bad_request
      end
    end

    describe "retire" do
      it "retires a product that exists" do
        delete product_path(product)
        must_redirect_to root_path
      end
      it "does not remove product from the database, only retires it" do
        proc {
          delete product_path(product)
          must_redirect_to root_path
        }.must_change 'Product.count', 0
      end
      it "returns 404 for a product that does not exist" do
        product_id = Product.last.id + 1
        delete product_path(product_id)
        must_respond_with :missing
      end
      it "does not remove a product from the database" do
        proc {
          product_id = Product.last.id + 1
          delete product_path(product_id)
        }.must_change 'Product.count', 0
      end
    end
  end
end
