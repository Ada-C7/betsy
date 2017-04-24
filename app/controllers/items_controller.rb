class ItemsController < ApplicationController
skip_before_action :require_login, only: [:index, :show]

# Price must be a number
# Price must be greater than 0


  before_action :find_categories, only: [:show, :edit]

  def index
    if params[:category_id]
      # we are in the nested route
      # retrieve items based on the genre
      # @items = Item.includes(:category).where(category: { id: params[:category_id]})
      @items = Item.includes(:categories).where(categories: { id: params[:category_id]})
    else
      # we are in our 'regular' route
      @items = Item.all
    end

  end

  def show
    @item = Item.find_by_id(params[:id])
    @reviews = Review.where(item_id: @item.id)

    if !@item
      # render_404
    end
  end


  def new
    @item = Item.new
  end

  def create
    @item = Item.new item_params
    @item.merchant_id = find_merchant.id
    @item.category_ids = params[:item][:category_ids]

    @item.save
    unless @item.merchant_id == nil
      redirect_to items_path, flash: {success: "Item added successfully"}
    else
      flash.now[:error] = "Error has occured"
      render "new"
    end
  end





  def edit
    @item=Item.find_by(id: params[:id])
    # if @item.nil?
    #   head :not_found
    # else
    #   params[:category] = @item.category
    # end
  end

  def update
    @item = Item.find_by(id: params[:id])

    @item.name = item_params[:name]
    @item.category_ids = params[:item][:category_ids]
    # raise
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render "edit"
    end
  end

  def destroy
    Item.destroy(params[:id])
    redirect_to items_path
  end

  def add_to_cart

    # Order.new(item.id)
    # item.order.status = "in cart"


    # where(session: (session[:id]).order(vote_count: :desc).limit(10)
    # order.where(session: session[:user_id]).where(work_id: params[:id]) == []    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :inventory, :merchant_id, :category_ids)
  end

  def find_item
    @item = Item.find_by_id(params[:id])
  end

  # #added by AE
  # def has_cart
  #   if OrderItem.where(order_id: Order.where(session_id: session[:user_id]))
  #     if Order.Where(status: "pending")
  #     end
  #   end
  # end

    def find_user
      if session[:merchant_id]
        @login_user = User.find_by(id: session[:user_id])
      end
    end

    def find_categories
      @categories = Category.all
      @categories_names = []
      @categories.each do |category|
        @categories_names << category.name
      end
      # raise
      return @categories_names
    end

end
