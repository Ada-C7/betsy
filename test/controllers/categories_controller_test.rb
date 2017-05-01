require "test_helper"

describe CategoriesController do
  describe "index" do
    it "lists all the categories" do
      Category.count.must_be :>, 0
      get categories_path
      must_respond_with :success
    end

    it "still responds successfully when there are no works" do
      Category.destroy_all
      get categories_path
      must_respond_with :success
    end

  end

  describe "new" do
    it "successfully loads the new product page" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "adds a product to the database" do
      start_count = Category.count
      category_data = {category:{name:"cards"}}

      post categories_path, params: category_data
      must_redirect_to categories_path
      end_count = Category.count
      end_count.must_be :==, start_count + 1
    end

    it "does not add bad categories to the database"do
      start_count = Category.count
      category_data = {category:{name:""}}
      post categories_path, params: category_data
      must_respond_with :bad_request
      end_count = Category.count
      end_count.must_be :==, start_count

    end
  end

  describe "destroy" do
    it "destroys a record in the database" do
      category =categories(:one)
      start_count = Category.count
      delete category_path(category)
      must_redirect_to categories_path
      end_count = Category.count

      end_count.must_be :==, start_count - 1
    end
  end

end
