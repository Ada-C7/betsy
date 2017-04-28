require "test_helper"

describe CategoriesController do


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

    it "does not allow a blank category to be made" do
      post categories_path
      flash[:status].must_equal :failure
      must_respond_with :redirect
    end
  end # END of describe "create"

end
