require 'rails_helper'

RSpec.describe Api::V1::DishesController, type: :controller do
  describe 'GET #index' do
    it "assigns @dishes" do
      dish = create(:dish)
      get :index
      expect(assigns(:dishes)).to eq([dish])
    end

    it "responds with status ok" do
      get :index, format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST #create' do

  end

  describe 'GET #show' do
    let(:dish) { create(:dish) }
    it "assigns @dish" do
      get :show, id: dish
      expect(assigns(:dish)).to eq(dish)
    end

    it "responds with status ok" do
      get :show, { id: dish, format: :json }
      expect(response).to have_http_status :ok
    end
  end

  describe 'PATCH #update' do
  end

  describe 'DELETE #destroy' do
  end
end
