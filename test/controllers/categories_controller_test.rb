require "test_helper"

#copied this line from the books_app controller test
class CategoriesControllerTest < ActionDispatch::IntegrationTest
    describe CategoriesController do
        #wrap in logged in
        describe "a user is logged in" do
            before do
                login_user(users(:felix))
            end
            it "should show the new form" do
                get new_category_path
                must_respond_with :success
            end

            it "can create a new category" do
                get auth_github_callback_path
                post categories_path, params: { category: {name: "funky"}}
                must_respond_with :redirect
                must_redirect_to user_path(users(:felix).id)
            end


            it "should affect the model when creating a category" do
                proc {
                    get auth_github_callback_path
                    post categories_path, params: { category: {name: "sci-fi"}}
                }.must_change 'Category.count', 1
            end
        end


        describe "a user is not logged in" do
            it "should get index" do
                get categories_path
                must_respond_with :success
            end
        end
    end
end
