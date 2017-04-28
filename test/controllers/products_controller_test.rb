require "test_helper"

describe ProductsController do

  describe "root" do
    it "Responds successfully" do
      Product.count.must_be :>, 0
      puts Product.count
      get root_path
      must_respond_with :success
    end

    it "Still responds successfully when there are no products" do
      Product.destroy_all
      get root_path
      must_respond_with :success
    end
  end # END of describe "index" do

  describe "index" do
    it "Responds successfully" do
      Product.count.must_be :>, 0
      # puts Product.count
      get products_path
      must_respond_with :success
    end

    it "Still responds successfully when there are no products" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end
  end # END of describe "index" do

  describe "new" do
    it "Directs to the right form" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new work" do
      login(merchants(:grace))
      start_count = Product.count

      product_data = {
        product: {
          name: 'Food23',
          price: 7.30,
          category: 'Cat1',
          description: 'Very good',
          image:' NomNom.png',
          inventory: 3,
          status: 'active',
          # merchant: 'merchant1'
        }
      }

      post products_path, params: product_data

      end_count = Product.count
      end_count.must_equal start_count + 1
    end
  end # END of describe "create"

  describe "show" do
    it "shows a product that exist" do
      # product = products(:product1)
      product = Product.first
      get product_path(product)
      must_respond_with :success
    end

    it "return 404 not found status when product does NOT exist" do
      product_id = 42
      get product_path(product_id)
      must_respond_with :not_found
    end
  end # END of describe "show"

  describe "edit" do
    it "routes to the edit page" do
      product = products(:product1)
      get edit_product_path(product)
      must_respond_with :success
    end
  end # END of describe "edit"

  describe "status" do
    it "check if found" do
      product = products(:product1)
      patch status_path(product)
      must_respond_with :found
    end
  end # END of describe "edit"

  describe "new_category" do
    it "Directs to the right form" do
      product = products(:product1)
      get product_new_category_path(product)
      must_respond_with :success
    end
  end
end
