require "test_helper"

describe CategoriesController do
  CATEGORIES = %w(albums books movies)
  INVALID_CATEGORIES = ["nope", "42", "  ", "albumstrailingtext"]

  describe "index" do
    it "succeeds with many categories" do
      # Assumption: there are many users in the DB
      Category.count.must_be :>, 0

      get categories_path
      must_respond_with :success
    end

    it "succeeds with no categories" do
      # Start with a clean slate
      Category.destroy_all

      get categories_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an extant category" do
      get category_path(Category.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus category" do
      # User.last gives the user with the highest ID
      bogus_category_id = Category.last.id + 1
      get category_path(bogus_category_id)
      must_respond_with :not_found
    end

    it "renders 404 not_found for a bogus category" do
      INVALID_CATEGORIES.each do |invalid|
        # get "categories/#{category}"
        get category_path(invalid)
        must_respond_with :not_found
      end
    end
  end

  describe "new" do
    it "succeeds for a real category" do
      CATEGORIES.each do |category|
        get new_category_path(category)
        must_respond_with :success
      end
    end
  end

  describe "create" do
    it "creates a category with valid data for a real category" do
      category_data = {
        category: {
          name: "testcategory"
        }
      }
      start_count = Category.count
      post categories_path, params: category_data
      must_redirect_to categories_path
      Category.count.must_equal start_count + 1
    end

    it "wouldn't be created without name" do
      category_data = {
        category: {
          name: ""
        }
      }
      start_count = Category.count
      post categories_path, params: category_data
      must_respond_with :bad_request
      Category.count.must_equal start_count
    end
  end
end
