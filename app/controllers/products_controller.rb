class ProductsController < ApplicationController

  def root
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Work.new(media_params)
    # @product.merchant_id = session[:merchant_id]
    @product.merchant_id = 1 #Just for tests
    if @product.save
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created #{@product.id}"
      redirect_to
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.id}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end

  end

  def show
    @product = Product.find_by(id: params[:id])
  end

end
