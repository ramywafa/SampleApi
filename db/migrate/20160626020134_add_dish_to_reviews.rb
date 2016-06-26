class AddDishToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :dish, index: true, foreign_key: true
  end
end
