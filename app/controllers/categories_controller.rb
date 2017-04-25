class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(name: params[:category][:name])
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully added category"
      redirect_to :root
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update profile"
      flash.now[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit; end

  def update; end

end
