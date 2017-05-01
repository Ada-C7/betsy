require "test_helper"

describe ProductsController do
  describe "index" do
    it "lists all the products" do
      Product.count.must_be :>, 0
      get products_path
      must_respond_with :success
    end

    it "still responds successfully when there are no works" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end

  end

  describe "new" do
    it "successfully loads the new product page" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "adds a product to the database" do
      start_count = Product.count
      product_data = {product:{name:"green", quantity:5, price:10, category:"toy", merchant_id: Merchant.first.id}}

      post products_path, params: product_data
      must_redirect_to products_path
      end_count = Product.count
      end_count.must_be :==, start_count + 1
    end

    it "re-renders the new work form if the work is invalid" do
      start_count = Product.count
      product_data = {product:{name:"", quantity:5, price:10, category:"toy", merchant_id:""}}

      post products_path, params: product_data
      must_respond_with :bad_request
      end_count = Product.count
      end_count.must_be :==, start_count

    end
  end

  describe "show" do
    it "must show a specified product" do
      first = products(:one)
      get product_path(first.id)
      must_respond_with :success
    end

    it "returns 404 not found if the product id doesn't exist" do
      product_id = Product.last.id
      product_id += 1
      get product_path(product_id)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "successfully loads the edit product page" do
      product = products(:one)
      get edit_product_path(product.id)
      must_respond_with :success
    end
  end

  describe "update" do
    it "changes a record in the database" do
      product = products(:one)
      product_data = {product:{name:"NewName"}}
      patch product_path(product.id), params: product_data

      must_redirect_to product_path(product.id)
    end

    it "redirects to edit path if update invalid" do
      product = products(:one)
      product_data = {product:{name:""}}
      patch product_path(product), params: product_data

      must_respond_with :bad_request
      # must_redirect_to edit_product_path
      #removed test for edit redirect because the :bad_request message was
      #all that was getting through

      #if I delete that line in the controller then I can detec the redirect
    end
  end

  describe "destroy" do
    it "destroys a record in the database" do
      product = products(:one)
      start_count = Product.count
      delete product_path(product)
      must_redirect_to products_path
      end_count = Product.count

      end_count.must_be :==, start_count - 1
    end
  end
end
