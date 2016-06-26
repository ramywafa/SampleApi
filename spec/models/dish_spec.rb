require 'rails_helper'

describe Dish, type: :model do
  
  it "has a valid factory" do
    build(:dish).should be_valid
  end

  let(:dish) { build(:dish) }
  
  describe "ActiveModel validations" do
    # Basic validations
    it { dish.should validate_presence_of(:name) }
    it { dish.should validate_presence_of(:description).with_message(
      "is too short (minimum is 3 characters)") }
    it { dish.should validate_presence_of(:creator) }
    it { dish.should validate_length_of(:description).is_at_least(3) }
  end
end
