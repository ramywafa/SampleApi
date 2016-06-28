require 'rails_helper'

describe Review, type: :model do
  
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  let(:review) { build(:review) }
  
  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:content).with_message(
      "is too short (minimum is 2 characters)") }
    it { is_expected.to validate_length_of(:content).is_at_least(2) }
    it { is_expected.to validate_presence_of(:dish) }
    it { is_expected.to validate_presence_of(:rating).with_message("is not a number") }
    it { is_expected.to validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_presence_of(:reviewer) }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to(:reviewer) }
    it { is_expected.to belong_to(:dish) }
  end
end
