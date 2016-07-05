class DishesController < ApplicationController
  before_action :load_dish, only: [:show, :edit]

  def index
    @dishes = Dish.page(params[:page])
  end

  def show
  end

  def new
    @dish = Dish.new
  end

  def edit
  end

private
  def load_dish
    @dish = Dish.find params[:id]
  end
end
