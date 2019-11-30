class HomeController < ApplicationController
  def index
    @products = Product.ne(status: 'inactive').to_a
    @categories = Category.ne(status: 'inactive').in(id: @products.collect{|x| x.category_id}.uniq).to_a
  end
end
