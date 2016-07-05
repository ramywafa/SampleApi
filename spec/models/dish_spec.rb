require 'rails_helper'

describe Dish, type: :model do

  it "has a valid factory" do
    expect(build(:dish)).to be_valid
  end

  let(:dish) { build(:dish) }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:creator) }
    it { is_expected.to validate_presence_of(:description).with_message(
      "is too short (minimum is 3 characters)") }
    it { is_expected.to validate_length_of(:description).is_at_least(3) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to(:creator) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end
end
