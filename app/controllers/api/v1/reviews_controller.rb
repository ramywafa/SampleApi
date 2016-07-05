class Api::V1::ReviewsController < Api::BaseController
  before_action :load_dish
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :validate_current_client_is_admin_or_reviewer, only: [:update, :destroy]

  def index
    respond_with @reviews = @dish.reviews.page(page)
  end

  def create
    @review = @dish.reviews.build review_params
    @review.reviewer = current_client
    @review.save
    respond_with @review, status: :created
  end

  def show
    respond_with @review
  end

  def update
    @review.update(review_params)
    respond_with @review.reload
  end

  def destroy
    respond_with @review.destroy
  end

private
  def load_dish
    @dish = Dish.find params[:dish_id]
  end

  def load_review
    @review = Review.find params[:id]
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  def validate_current_client_is_admin_or_reviewer
    if current_client.nil? || (current_user.present? && current_user != @review.reviewer)
      fail Unauthorized
    end
  end
end
