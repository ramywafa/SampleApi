require 'rails_helper'

describe User, type: :model do
  
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:dishes).dependent(:destroy) }
  end
end
