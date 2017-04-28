require "test_helper"

describe ProductsController do

  describe "root" do
    it "Responds successfully" do
      Product.count.must_be :>, 0
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
      get products_path
      must_respond_with :success
    end

    it "Still responds successfully when there are no products" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end

    it "Responds successfully for a category" do
      category = categories(:category1)
      get category_products_path(category.id)
      must_respond_with :success
    end

  end # END of describe "index" do

  describe "new" do
    it "Directs to the right form" do
      login(merchants(:grace))
      get new_product_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new product" do
      login(merchants(:grace))
      start_count = Product.count

      product_data = { product: {
                                  name: 'Food23',
                                  price: 7.30,
                                  description: 'Very good',
                                  image:' NomNom.png',
                                  inventory: 3,
                                  status: 'active'
                                }
                      }

      post products_path, params: product_data
      end_count = Product.count
      end_count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for bogus data" do
      login(merchants(:grace))
      start_count = Product.count
      product_data = { product: { name: 'Food23' } }
      post products_path, params: product_data
      end_count = Product.count
      end_count.must_equal start_count
      end
  end # END of describe "create"

  describe "show" do
    it "shows a product that exist" do
      product = Product.first
      get product_path(product)
      must_respond_with :success
    end

    it "return 404 not found status when product does NOT exist" do
      product_id = 42
      get product_path(product_id)
      flash[:status].must_equal :failure
      must_respond_with :redirect
    end
  end # END of describe "show"

  describe "edit" do
    it "routes to the edit page" do
      login(merchants(:grace))
      product = products(:product1)
      get edit_product_path(product)
      must_respond_with :success
    end

    it "redirects to products page if product DNE" do
      login(merchants(:grace))
      product_id = 42
      get edit_product_path(product_id)
      flash[:status].must_equal :failure
      must_respond_with :redirect
      must_redirect_to products_path
    end
  end # END of describe "edit"

  describe "update" do
    it "Update a product and redirect" do
      login(merchants(:grace))
      product1 = products(:product1)
      product_data = { product: {
                                  name: 'Food111',
                                  price: 7.30,
                                  description: 'Very good',
                                  image: 'NomNom.png',
                                  inventory: 3,
                                  status: 'active'
                                }
                      }

      patch product_path(product1), params: product_data
      Product.find_by(id: product1.id).name.must_equal product_data[:product][:name]
    end

    it "Failure at update due to bogus values" do
      login(merchants(:grace))
      product1 = products(:product1)
      product_data = { product: {
                                  name: 'Food111',
                                  price: 7.30,
                                  description: 'Very good',
                                  image: 'NomNom.png',
                                  status: 'active',
                                  inventory: 'bogus data'
                                }
                      }
      patch product_path(product1), params: product_data
      flash[:status].must_equal :failure
      Product.find_by(id: product1.id).inventory.must_equal 3
    end
  end # END of describe "update"

  describe "status" do

    it "changes status of an product" do
      login(merchants(:grace))
      product = products(:product1)
      patch status_path(product)
      must_respond_with :found
    end

    it "wont allow non-longed in user to change status" do
      product = products(:product1)
      status_before = product.status
      patch status_path(product)
      status_after = product.status
      status_after.must_equal status_before
    end
  end # END of describe "edit"

  describe "new_category" do
    it "Directs to the right form" do
      login(merchants(:grace))
      product = products(:product1)
      get product_new_category_path(product)
      must_respond_with :success
    end
  end

  describe "create_category" do
    it "adds a category to a product that already has a category" do
      login(merchants(:grace))
      #product 1 has category meat
      product1 = products(:product1)
      # category3 is salad
      category3 = categories(:category3)
      categories_for_a_product = product1.categories
      product_id = product1.id
      category_id = category3.id
      post product_categories_path(product1.id), params: {product_id: product1.id, category_id: category3.id}
      Product.find_by(id: product1.id).categories.count.must_equal 2
    end

    it "wont create a category that is already made" do
      login(merchants(:grace))
      product1 = products(:product1)
      category1 = categories(:category1)
      categories_for_a_product = product1.categories
      product_id = product1.id
      category_id = category1.id
      post product_categories_path(product1.id) , params: {product_id: product1.id, category_id: category1.id}
      Product.find_by(id: product1.id).categories.map(&:name).count.must_equal 1
    end
  end
end # END of describe ProductsController
