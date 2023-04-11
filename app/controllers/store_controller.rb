class StoreController < ApplicationController
  def index
    record_index_access
    @products = Product.order(:title)
  end

  private
    def record_index_access
      if session[:index_access_counter].nil?
        session[:index_access_counter] = 1
      else
        session[:index_access_counter] += 1
      end
    end
end
