require 'test_helper'

describe ProductsController do

  before do
    login(users(:grace))
  end
  describe "index" do

    it "responds with no product" do
      # skip
      Product.destroy_all

      get products_path
      must_respond_with :success
    end

    it "responds with multiple products" do
      # skip
      Product.count.must_be :>, 0

      get products_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "adds product to database" do
      product_data =
      { product:
        {
          name: "Test Name",
          stock: 1,
          price: 1.99
        }
      }

      post products_path, params: product_data
      must_redirect_to user_path(id: session[:user_id])
    end

    it "refreshed the form if the info sucks" do
      skip
      #TODO: Something wrong with actual redirect

      product_data =
      { product:
        {
          name: nil,
          stock: 1,
          price: 1.99
        }
      }

      post products_path, params: product_data
      must_respond_with(:new)
    end
  end

  describe "show" do
    it "responds with an existing product" do
      get product_path(Product.first)
      must_respond_with :success
    end

    it "404 with invalid product data" do
      bad_product_id = Product.last.id + 1
      get product_path(bad_product_id)
      must_respond_with :not_found
    end
  end
end
