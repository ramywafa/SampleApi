# == Schema Information
#
# Table name: reviews
#
#  id            :integer          not null, primary key
#  reviewer_id   :integer
#  reviewer_type :string(255)
#  rating        :integer
#  content       :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  dish_id       :integer
#
# Indexes
#
#  index_reviews_on_dish_id                        (dish_id)
#  index_reviews_on_reviewer_type_and_reviewer_id  (reviewer_type,reviewer_id)
#
# Foreign Keys
#
#  fk_rails_20a1166865  (dish_id => dishes.id)
#

class Review < ActiveRecord::Base
  belongs_to :dish
  belongs_to :reviewer, polymorphic: true
end
