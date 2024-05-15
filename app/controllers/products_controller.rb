class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_seller, only: [:edit, :update, :destroy]
  def index
    @products = Product.all
    @products = @products.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def buy
    @product = Product.find(params[:id])
    @buyer = Buyer.find_by(user_id: session[:user_id])

    if @buyer.nil?
      redirect_to root_path, alert: "You need to have a buyer account to buy products."
      return
    end

    if @product.stock <= 0
      redirect_to @product, alert: "This product is out of stock."
      return
    end

    transaction = Transaction.new(product: @product, buyer: @buyer, quantity: 1)
    if transaction.save
      @product.update(stock: @product.stock - 1)
      redirect_to @product, notice: "Product successfully purchased."
    else
      redirect_to @product, alert: "Failed to purchase the product."
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @seller = Seller.find_by(user_id: session[:user_id])

    if @seller.present?
      @product = @seller.products.new(product_params)
    end 

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product.seller_id = current_user.id if current_user.seller?

    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :seller_id)
  end

  private

  def require_seller
    unless current_user && current_user.seller
      redirect_to root_path, alert: "You don't have permission to access this page."
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock)
  end
end
