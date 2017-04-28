require "test_helper"

describe ProductsController do
    describe "a logged in user" do
        before do
            login_user(users(:felix))
        end
        describe "#New logged in" do
            it "should get a form for a new product" do
                get auth_github_callback_path
                get new_product_path
                must_respond_with :success
            end

            it "should not go to new product form if no logged in user" do
                get new_product_path
                must_respond_with :success
            end

            it "should be able to add new product if logged in user" do
                get auth_github_callback_path
                get new_product_path
                must_respond_with :success
            end
        end

        describe "#Create" do
            it "should redirect to index after creating a new product" do
                get auth_github_callback_path

                post products_path params: { product: {name: "My new Product",description: "This is great!",stock: 123,price: 12400.00,photo_url: "www.url.com",selling_status: true,category_ids: [categories(:fiction).id, categories(:nonfiction).id]} }
                # product.user_id = users(:felix).id
                must_respond_with :redirect
                must_redirect_to products_path
            end

            it "should update model after creating a new product" do
                get auth_github_callback_path
                proc { post products_path params: { product: { name: "My new Product",description: "This is great!",stock: 123,price: 12400.00,photo_url: "www.url.com",selling_status: true,category_ids: [categories(:fiction).id, categories(:nonfiction).id]} }}.must_change 'Product.count', 1
            end

            it "should not update model with bad data" do
                get auth_github_callback_path
                proc { post products_path params: { product: {name: "", description: "This is great!", stock: 123,price: 00,photo_url:"www.url.com",selling_status: true,category_ids: []} } }.must_change 'Product.count', 0
            end
        end

        describe "#Edit" do
            it "should get a form to edit a product" do
                get edit_product_path(products(:umbrella))
                must_respond_with :success
            end
        end

        describe "#Update" do
            it "should redirect to show page after creating a new product" do
                put product_path(products(:umbrella).id), params: { product: {name: "Umbrella",user_id: users(:aurora).id,description: "This is great!",stock: 123,price: 12400.00,photo_url: "www.url.com",selling_status: true,category_ids: [categories(:fiction).id, categories(:nonfiction).id]} }
                must_respond_with :redirect
                must_redirect_to product_path(products(:umbrella).id)
            end

            it "should update info of model if data is valid" do
                old_name = products(:umbrella).name
                put product_path(products(:umbrella).id), params: { product: {name: "NEW Umbrella",user_id: users(:aurora).id,description: "This is great!",stock: 123,price: 12400.00,photo_url: "www.url.com",selling_status: true,category_ids: [categories(:fiction).id, categories(:nonfiction).id]} }
                umbrella = Product.find_by_id(products(:umbrella).id)
                new_name = umbrella.name

                new_name.wont_equal old_name
            end

            it "should not update model if data is bad" do
                old_name = products(:umbrella).name
                put product_path(products(:umbrella).id), params: { product: {name: "",user_id: 1,description: "This is great!",stock: 123,price: 12400.00,photo_url: "www.url.com",selling_status: true,category_ids: [categories(:fiction).id, categories(:nonfiction).id]} }

                umbrella = Product.find_by_id(products(:umbrella).id)
                new_name = umbrella.name

                new_name.must_equal old_name
            end
        end

        describe "#status" do
            it "can change status from true to false" do
                get auth_github_callback_path
                get user_path(users(:aurora).id)
                patch status_path(users(:aurora).products.first.id)
                users(:aurora).products.first.selling_status.must_equal false
            end

            it "can change status from false to true" do
                get auth_github_callback_path
                get user_path(users(:aurora).id)
                patch status_path(users(:aurora).products.first.id)
                patch status_path(users(:aurora).products.first.id)
                users(:aurora).products.first.selling_status.must_equal true
            end
        end
    end

    describe "a not logged in user can" do
        #everyone can get to this
        describe "#Index" do
            it "should get index" do
                get products_path
                must_respond_with :success
            end

            it "works with multiple works" do
                Product.count.must_be :>, 0
                get products_path
                must_respond_with :success
            end

            it "still works if there are no products" do
                Product.destroy_all
                get products_path
                must_respond_with :success
            end

            it "can filter by merchant" do
                get user_products_path(users(:felix))
                must_respond_with :success
            end

            it "can filter by category" do
                get category_products_path(categories(:fiction))
                must_respond_with :success
            end
        end

        describe "#Show" do
            it "should show one product" do
                get product_path(products(:umbrella).id)
                must_respond_with :success
            end

            it "should show a 404 if product not found" do
                get product_path(1)
                must_respond_with :missing
            end
        end
    end
end
