require "test_helper"

describe ProductsController do


  describe "Guest User" do
    describe "show" do
      it "should get show" do
        get product_path(products(:cat_jacket))
        must_respond_with :success
      end

      it "returns a 404 if the product doesn't exist" do
        product_id = Product.last.id
        product_id += 1
        get product_path(product_id)

        must_respond_with :not_found
      end
    end

    it "shows index" do
      get product_path(Product.first)
      must_redirect_to products_path
    end

    it "succeeds when there are no products" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end
  end

  # describe "logged in user" do
  #   before do
  #     login(users(:andrea))
  #   end
  #
  #   describe "new" do
  #     it "should get new" do
  #       @current_user = merchants(:merchant_1)
  #       get new_product_path
  #       must_respond_with :success
  #     end
  #   end
  #
  #   describe "create" do
  #
  #     let(:dog_jacket) {
  #       { product: {
  #         product_name: "Dog Jacket",
  #         price: 19.99,
  #         merchant_id: Merchant.first.id,
  #         photo_url: "http://pinxpets.com/cat-rain-jacket/",
  #         stock: 5,
  #         product_description: "soooo waterproof but not breathable; mild activity only"}}
  #       }
  #
  #       it "should get create" do
  #         post "auth/github/callback", params: {}
  #         @current_user = merchants(:merchant_1)
  #         post products_path, params: dog_jacket
  #         must_redirect_to  products_path
  #       end
  #
  #       it "renders the form if invalid input " do
  #         @current_user = merchants(:merchant_1)
  #         dog_jacket[:price] = nil
  #         post products_path, params: dog_jacket
  #         must_respond_with :bad_request
  #       end
  #
  #       it "adds a new user to the database " do
  #         before = Product.all.size
  #         @current_user = merchants(:merchant_1)
  #         dog_jacket[:price] = nil
  #         post products_path, params: dog_jacket
  #         Product.all.size.must_equal before + 1
  #       end
  #     end
  #
  #     describe "edit" do
  #       it "succeeds for an extant work ID" do
  #         get edit_product_path(Product.last.id)
  #         must_respond_with :success
  #       end
  #
  #       it "renders 404 not_found for a bogus work ID" do
  #         bogus_product_id = Product.last.id + 1
  #         get edit_product_path(bogus_product_id)
  #         must_respond_with :not_found
  #       end
  #     end
  #   end
  #
  #   describe "update" do
  #     it "adds work to database and redirects" do
  #       product = products(:cat_jacket)
  #       patch product_path(product.id), params: {product: {product_name: "UPDATED!" } }
  #
  #       must_respond_with :redirect
  #
  #       product.reload
  #       puts product
  #       product.product_name.must_equal "UPDATED!"
  #
  #     end
  #   end
  #
  #   describe "destroy" do
  #     it "succeeds for an extant work ID" do
  #       before = Product.all.size
  #       product_id = Product.first.id
  #
  #       delete product_path(product_id)
  #       must_redirect_to merchant_path(@current_user.id)
  #
  #       # The work should really be gone
  #       Product.find_by(id: work_id).must_be_nil
  #       Product.all.size.must_equal before - 1
  #     end
  #
  #     it "renders 404 not_found and does not update the DB for a bogus work ID" do
  #       before_count = Product.count
  #
  #       fake_product_id = Product.last.id + 1
  #       delete product_path(fake_product_id)
  #       must_respond_with :not_found
  #
  #       Product.count.must_equal start_count
  #     end
  #   end

  end
