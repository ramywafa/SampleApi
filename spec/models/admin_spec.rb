require 'rails_helper'

describe Admin, type: :model do
  
  it "has a valid factory" do
    expect(build(:admin)).to be_valid
  end

  let(:admin) { build(:admin) }

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:dishes).dependent(:destroy) }
  end
end
