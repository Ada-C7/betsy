require "test_helper"

describe CategoriesController do
  let(:category) { categories(:comfy) }

  describe "new" do
    it "runs successfully" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new category" do
      post categories_path, params: { category: { name: 'cozy'} }
      must_redirect_to root_path
    end

    it "adds a new category to the database" do
      proc {
        post categories_path, params: { category: { name: 'cozy'} }
      }.must_change 'Category.count', 1
    end

    it "returns 404 and fails to create a new category w invalid data" do
      post categories_path, params: { category: { name: nil } }
      must_respond_with :bad_request
    end

    it "does not add a new category to the database" do
      proc {
        post categories_path, params: { category: { name: nil } }
      }.must_change 'Category.count', 0
    end
  end

  describe "destroy" do
    it "deletes a category that exists" do
      delete category_path(category)
      must_redirect_to root_path
    end

    it "removes category from database" do
      skip
      proc {
        delete category_path(category)
        must_redirect_to root_path
      }.must_change 'Category.count', -1
    end

    it "returns 404 for a category that does not exist" do
      skip
      category_id = Category.last.id + 1
      delete category_path(Category.find_by_id(category_id))
      must_respond_with :missing
    end

    it "does not remove a category from the database" do
      skip
      proc {
        category_id = Category.last.id + 1
        delete category_path(Category.find_by_id(category_id))
      }.must_change 'Category.count', 0
    end
  end

end
