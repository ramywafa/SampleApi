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
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_numericality_of(:rating).is_between(1, 5) }
    it { is_expected.to validate_presence_of(:reviewer) }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to(:creator) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end
end
