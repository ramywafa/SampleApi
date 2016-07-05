class DishesController < ApplicationController
  before_action :load_dish, only: [:show, :edit]

  def index
    page = params[:page] || 1
    response = RestClient.get("http://localhost:3000/api/dishes?page=#{page}")
    @dishes = Kaminari.paginate_array(JSON.parse(response.body)['dishes']).page(page)
  end

  def show
    response = RestClient.get("http://localhost:3000/api/dishes/#{params[:id]}")
    @dish = JSON.parse(response.body)['dish']
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
