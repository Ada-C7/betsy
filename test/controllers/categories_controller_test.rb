require "test_helper"

describe CategoriesController do
  describe "index" do
    it "Responds successfully" do
      Category.count.must_be :>, 0
      get categories_path
      must_respond_with :success
    end
  end



  describe "new" do
    it "Directs to the right form" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new work" do
      # login(merchants(:grace))
      start_count = Category.count

      category_data = {
        category: {
          name: 'fish',
        }
      }
      post categories_path, params: category_data
      end_count = Category.count
      end_count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for bogus data" do
      start_count = Category.count
      category_data = {
        category: {
          name: 'vegan',
        }
      }
      post categories_path, params: category_data
      end_count = Category.count
      end_count.must_equal start_count
    end
  end # END of describe "create"

end
