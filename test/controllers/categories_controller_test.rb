require "test_helper"


describe CategoriesController do

  describe "Logged in User tests" do

    before do
      user = merchants(:dan)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
    end

      it "should get index" do
        get categories_path
        must_respond_with :success
      end


      it "should get new" do
        get new_category_path
        must_respond_with :ok
      end


    it "should be able to create a new category" do
      proc {
        post categories_path, params: { category: { name: "spoopy" }  }
      }.must_change 'Category.count', 1

      must_respond_with :redirect
      must_redirect_to categories_path
    end

    it "can't create a new category with invalid parameters" do
      proc {
        post categories_path, params: { category: {name: ""}  }
      }.must_change 'Category.count', 0
    end
  end

  describe "guest Users" do

    it "user can't get new category page if they are not logged in" do
      get new_category_path
      must_respond_with :found
    end

    it "user can't create category if they are not logged in" do
      proc {
        post categories_path, params: { category: { name: "spoopy" }  }
      }.must_change 'Category.count', 0
    end


  end
end
