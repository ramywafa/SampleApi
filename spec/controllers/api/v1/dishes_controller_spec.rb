require 'rails_helper'

RSpec.describe Api::V1::DishesController, type: :controller do
  describe "Actions" do
    it { is_expected.to use_before_action(:authenticate_client!) }
    it { is_expected.to use_before_action(:sign_client_in) }
    it { is_expected.to use_before_action(:load_dish) }
    it { is_expected.to use_before_action(:validate_current_client_is_admin_or_creator) }
  end

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
    shared_examples_for "Admin user" do
      context "with valid params" do
        before(:each) do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          @dish_original_count = Dish.count
          @dish_params = FactoryGirl.attributes_for(:dish)
          post :create, { dish: @dish_params, format: :json }
        end
        it "Should increase the number of dishes" do
          expect(Dish.count).to eq(@dish_original_count + 1)
        end

        it "should increase the resource's number of dishes" do
          expect(resource.dishes.count).to eq 1
        end

        it "should respond with status created" do
          expect(response).to have_http_status(:created)
        end
      end

      context "with invalid params" do
        it "shouldn't create a dish when basic auth is not passed" do
          expect {
            post :create, { dish: @dish_params, format: :json }
          }.not_to change(Dish, :count)
        end

        it "should respond with status unauthorized" do
          post :create, { dish: @dish_params, format: :json }
          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context "with admin" do
      let(:resource) { create(:admin) }

      it_behaves_like "Admin user"
    end

    context "with user" do
      let(:resource) { create(:user) }

      it_behaves_like "Admin user"
    end
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
    shared_examples_for "Client" do

      context "with valid params" do
        before :each do
          @dish = create(:dish, name: "Chicken", description: "Some description", creator: creator)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          patch :update, id: @dish, format: :json,
              dish: { name: "Meat", description: "Other description" }
        end

        it "should assign @dish" do
          expect(assigns(:dish)).to eq(@dish)
        end

        it "should change dish attributes" do
          @dish.reload
          expect(@dish.name).to eq('Meat')
          expect(@dish.description).to eq('Other description')
        end

        it "should respond with ok" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        before :each do
          @dish = create(:dish, name: "Chicken", description: "Some description", creator: creator)
        end

        it "shouldn't update a dish when basic auth is not passed" do
          expect {
            patch :update, { id: @dish, dish: attributes_for(:dish), format: :json }
          }.not_to change(@dish, :name)
          expect {
            patch :update, { id: @dish, dish: attributes_for(:dish), format: :json }
          }.not_to change(@dish, :description)
        end

        it "should respond with status unauthorized" do
          patch :update, { id: @dish, dish: attributes_for(:dish), format: :json }
          expect(response).to have_http_status :unauthorized
        end

        it "should respond with not found when the given id is not found in the database" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          patch :update, { id: 5000, dish: attributes_for(:dish), format: :json }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "with admin" do
      let(:resource) { create(:admin) }
      let(:creator) { create(:user) }

      it_behaves_like "Client"
    end

    context "with user" do
      let(:resource) { create(:user) }
      let(:creator) { resource }

      it_behaves_like "Client"

      describe "User can't update a dish that wasn't created by him/her" do
        before :each do
          @dish = create(:dish, creator: create(:admin), name: 'Chicken')
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
        end

        it "should not update the dish attributes" do
          expect {
            patch :update, { id: @dish, dish: attributes_for(:dish), format: :json }
          }.not_to change(@dish, :name)
          expect {
            patch :update, { id: @dish, dish: attributes_for(:dish), format: :json }
          }.not_to change(@dish, :description)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    shared_examples_for "Client" do

      context "with valid params" do
        before :each do
          @dish = create(:dish, creator: creator)
          @dish_original_count = Dish.count
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          delete :destroy, id: @dish, format: :json
        end

        it "should assign @dish" do
          expect(assigns(:dish)).to eq(@dish)
        end

        it "should change dish count" do
          expect(Dish.count).to eq(@dish_original_count - 1)
        end

        it "should respond with ok" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        before :each do
          @dish = create(:dish, creator: creator)
          @dish_original_count = Dish.count
        end

        it "shouldn't delete a dish when basic auth is not passed" do
          expect {
            delete :destroy, { id: @dish, format: :json }
          }.not_to change(Dish, :count)
        end

        it "should respond with status unauthorized" do
          delete :destroy, { id: @dish, format: :json }
          expect(response).to have_http_status :unauthorized
        end

        it "should respond with not found when the given id is not found in the database" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          delete :destroy, { id: 5000, format: :json }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "with admin" do
      let(:resource) { create(:admin) }
      let(:creator) { create(:user) }

      it_behaves_like "Client"
    end

    context "with user" do
      let(:resource) { create(:user) }
      let(:creator) { resource }

      it_behaves_like "Client"

      describe "User can't delete a dish that wasn't created by him/her" do
        before :each do
          @dish = create(:dish, creator: create(:admin))
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
        end

        it "should not delete @dish" do
          expect {
            delete :destroy, { id: @dish, format: :json }
          }.not_to change(Dish, :count)
        end
      end
    end
  end
end
