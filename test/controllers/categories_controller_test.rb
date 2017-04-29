require 'test_helper'

describe CategoriesController do
    describe 'new' do
        it 'should get new' do
            get new_category_path
            must_respond_with :success
        end
    end

    describe 'create' do
        it 'add a category to the database' do
            start_count = Category.count

            category_data = { category: { name: 'Tofu' } }

            post categories_path, params: category_data
            must_redirect_to category_products_path(Category.last.id)

            end_count = Category.count
            end_count.must_equal start_count + 1

            category = Category.last
            category.name.must_equal category_data[:category][:name]
        end

        it 'renders bad_request for bogus data' do
        end
    end
end
