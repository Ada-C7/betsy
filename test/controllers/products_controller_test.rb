require "test_helper"

describe ProductsController do
  let(:product) { products(:kidjams, :famjams, :jamjams, :hotdamnjams).sample }

  describe "index" do
    it "is successful when there are many products" do
      Product.count.must_be :>, 0
      get products_path
      must_respond_with :success
    end

    it "successful when there are zero classrooms" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "runs successfully" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new product" do
      post products_path, params: { product: { user_id: users(:testuser).id, name: "jammies", quantity: 10, price: 5.0, description: "so cozy", image_url: "jams.jpg" } }
      must_redirect_to products_path
    end

    it "adds a new product to the database" do
      proc {
        post products_path, params: { product: { user_id: users(:testuser).id, name: "jammies", quantity: 10, price: 5.0, description: "so cozy", image_url: "jams.jpg" } }
      }.must_change 'Product.count', 1
    end

    it "returns 404 and fails to create a new product w invalid data" do
      post products_path, params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
      must_respond_with :ok
    end

    it "does not add a new product to the database" do
      proc {
        post products_path, params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
      }.must_change 'Product.count', 0
    end
  end

  describe "show" do
    it "finds a product that exists" do
      get product_path(product)
      must_respond_with :success
    end

    it "returns bad_request for a product that does not exist" do
      product_id = Product.last.id + 1
      get product_path(product_id)
      must_respond_with :missing
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
      must_redirect_to products_path
    end

    it "returns bad_request and fails to update product w invalid data" do
      patch product_path(product), params: { product: { name: "", quantity: 0, price: 0, description: "", image_url: "" } }
      must_respond_with :ok
    end
  end

  describe "destroy" do
    it "destroys a product that exists" do
      delete product_path(product)
      must_redirect_to products_path
    end

    it "removes a product from the database" do
      proc {
        delete product_path(product)
        must_redirect_to products_path
      }.must_change 'Product.count', -1
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
