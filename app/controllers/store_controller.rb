class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @count = increment_count
  end

  def increment_count
    @counter = session[:counter]
    @counter.nil? ? @counter = 1 : @counter+=1
    session[:counter] = @counter
  end
end
