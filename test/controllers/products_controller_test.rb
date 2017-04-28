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

      product_data = {
        product: {
          name: 'Food23',
          price: 7.30,
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


    it "renders bad_request and does not update the DB for bogus data" do
      login(merchants(:grace))
      start_count = Product.count
      product_data = {
        product: {
          name: 'Food23',
        }
      }
      post products_path, params: product_data
      end_count = Product.count
      end_count.must_equal start_count
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
      login(merchants(:grace))
      product = products(:product1)
      get edit_product_path(product)
      must_respond_with :success
    end

    it "return 404 not found status when product does NOT exist" do
      product_id = 42
      get edit_product_path(product_id)
      must_respond_with :not_found
    end
  end # END of describe "edit"

  describe "update" do
    it "Update a product and redirect" do
      login(merchants(:grace))
      product1 = products(:product1)
      product_data = {
        product: {
          name: 'Food111',
          price: 7.30,
          description: 'Very good',
          image: 'NomNom.png',
          inventory: 3,
          status: 'active',
          # merchant: 'merchant1'
        }
      }
      patch product_path(product1), params: product_data
      # must_redirect_to works_path
      Product.find_by(id: product1.id).name.must_equal product_data[:product][:name]
    end
  end # END of describe "update"

  ####### YIKE WHAT DO WE WANT TO HAPPEN?
  # it "wont allow non-login user route to edit page" do
  #   product = products(:product1)
  #   get edit_product_path(product)
  # end

  describe "status" do
    it "check if found" do
      product = products(:product1)
      patch status_path(product)
      must_respond_with :found
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
    it "adds a category" do
      product1 = products(:product1)
      category3 = categories(:category3)
      categories_for_a_product = product1.categories
      puts categories_for_a_product.map(&:name)
      product_id = product1.id
      category_id = category3.id
      post product_categories_path(product1.id) , params: {product_id: product1.id, category_id: category3.id}
      Product.find_by(id: product1.id).categories.map(&:name).count.must_equal 2
    end

    it "adds a category" do
      product1 = products(:product1)
      category1 = categories(:category1)
      categories_for_a_product = product1.categories
      puts categories_for_a_product.map(&:name)
      product_id = product1.id
      category_id = category1.id
      post product_categories_path(product1.id) , params: {product_id: product1.id, category_id: category1.id}
      Product.find_by(id: product1.id).categories.map(&:name).count.must_equal 1
    end
  end
end # END of describe ProductsController
