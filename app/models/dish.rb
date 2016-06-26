# == Schema Information
#
# Table name: dishes
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  image        :string(255)
#  creator_id   :integer
#  creator_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_dishes_on_creator_type_and_creator_id  (creator_type,creator_id)
#

class Dish < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :creator, polymorphic: true, dependent: :destroy
end
