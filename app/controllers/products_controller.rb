class ProductsController < ApplicationController
  # GET /products
  def index
    render json: JSON.pretty_generate('hello index');
  end

  # GET /products/1
  def show
    render json: JSON.pretty_generate('hello show');
  end
end
