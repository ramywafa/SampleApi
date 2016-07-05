class Api::V1::DishesController < Api::BaseController
  before_action :load_dish, only: [:show, :update, :destroy]
  before_action :validate_current_client_is_admin_or_creator, only: [:update, :destroy]

  def index
    respond_with @dishes = Dish.page(page)
  end

  def create
    @dish = Dish.new dish_params
    @dish.creator = current_client
    @dish.save
    respond_with @dish, status: :created
  end

  def show
    respond_with @dish
  end

  def update
    respond_with @dish.update(dish_params)
  end

  def destroy
    respond_with @dish.destroy
  end

private
  def load_dish
    @dish = Dish.find params[:id]
  end

  def dish_params
    params.require(:dish).permit(:name, :image, :description)
  end

  def validate_current_client_is_admin_or_creator
    if current_client.nil? || (current_user.present? && current_user != @dish.creator)
      fail Unauthorized
    end
  end
end
