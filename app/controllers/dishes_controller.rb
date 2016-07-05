class DishesController < ApplicationController
  before_action :load_dish, only: [:show, :edit]

  def index
    response = RestClient.get("http://localhost:3000/api/dishes")
    @dishes = JSON.parse(response.body)['dishes']
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
