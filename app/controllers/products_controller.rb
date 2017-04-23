class ProductsController < ApplicationController
    def index
        @categories = Category.all
        if params[:category_id]
            @products = Product.includes(:product_categories).where(product_categories: { category_id: params[:category_id] })
        else
            @products = Product.all
        end
    end

    def create
        Product.create(product_params)

        redirect_to products_path
    end

    def new
        @products = Product.new
    end

    def edit
        @product = Product.find(params[:id])
    end

    def show
        @product = Product.find_by_id(params[:id].to_i)
    end

    def update
        product = Product.find(params[:id])
        product.update(product_params)
    end

    private

    def product_params
        params.require(:product).permit(:stock, :name, :price, :user_id, :status)
        # Did not add photos to product_params.
    end
end
