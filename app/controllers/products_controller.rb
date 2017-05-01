class ProductsController < ApplicationController
  def index
    if params[:category_id]
      @products =  Product.by_category(params[:category_id])
    else
      @products = Product.all
    end
  end

  def new
    @product = Product.new
  end

  def create
    @categories = Category.all
    @product = Product.new(product_params)
    @product.merchant_id = session[:merchant_id]
    #This code is calling going into the params hash, then the product hash, then the category_ids.
    #It is then iterating through all the category ids, except the first
    #And for each category id, it is passing the given ID as an attribute for the product
    params[:product][:category_ids][1..-1].each{|id| @product.add_category(id)}
    #temporarily hard-coded worried the underlying form code doesn't work though
    @product.save
    if @product.save
      redirect_to products_path
    else
      render :new, status: :bad_request
      flash[:failure] = "Could not add your product"
      flash[:messages] = @product.errors.messages
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    head :not_found if @product.nil?

    @product_reviews = Review.where(product_id: params[:id])
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end


  def update
    @product = Product.find_by(id: params[:id])

    if @product.can_edit?(@current_merchant) == true
      @merchant = Merchant.find_by(id: 1)
      @product = Product.find_by(id: params[:id])
      @product.update_attributes(product_params)
      params[:product][:category_ids][1..-1].each{|id| @product.add_category(id)}
      @product.save

      if @product.save
        redirect_to product_path(params[:id])
      else
        render :edit, status: :bad_request
      end
    else
      flash[:message] = "You are unauthorized to edit this product"
      redirect_to product_path(@product)
    end
  end

  def review
    if @product.can_edit?(@current_merchant) == false
      @product = Product.find_by(id: params[:id])

      @product_review = Review.new(review_params)
      @product_review.product_id = params[:id]
      @product_review.save!
    else
      flash[:message] = "You are unauthorized to review this product"
      redirect_to product_path(@product)
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])

    if @product.can_edit?(@current_merchant) == true
      @product = Product.find_by(id: params[:id])
      @product.destroy
      redirect_to products_path
    else
      flash[:message] = "You are unauthorized to delete this product"
      redirect_to product_path(@product)
    end
  end

  def product_by_merchant
    id = session[:merchant_id]

    @product_by_merchant = Product.by_merchant(id)
    @merchants = Merchant.all
  end




  private
  def product_params
    return params.require(:product).permit(:name, :quantity, :category, :price, :description, :merchant_id, :img_url)
  end

  def review_params
    return params.require(:review).permit(:name, :product_id, :comment, :rating, :merchant_id)

  end
end
