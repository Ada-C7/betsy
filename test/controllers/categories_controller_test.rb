require "test_helper"

describe CategoriesController do
  let(:spa) {categories(:spa)}

  it "should get index" do
    get categories_path
    must_respond_with :success
  end

  it "should get form to create a new category" do
    get new_category_path
    must_respond_with :success
  end

  it "should require a name to create a new category" do
    spa.name = nil

  end

  it "should require that the category name is unique" do

  end

  it "should affect the model when a new category is added" do
    proc { post categories_path, params:
      { category: { name: "spicy" } }}.must_change 'Category.count', 1
  end

  it "should redirect to category index page after adding a new category" do skip
    post products_path, params: { categories:
      { name: "yummy"}
    }
    must_redirect_to category_show_path
    # will need to double check that this is the correct paht once it's been created
  end
end
