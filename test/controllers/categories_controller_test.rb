require "test_helper"

describe CategoriesController do
  let(:category) { categories(:comfy) }

  describe "logged in users" do
    before do
      login(users(:one))
    end

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

  end
end
