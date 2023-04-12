# frozen_string_literal: true

class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart

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
