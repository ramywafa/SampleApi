require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
  describe "Actions" do
    it { is_expected.to use_before_action(:authenticate_client!) }
    it { is_expected.to use_before_action(:sign_client_in) }
    it { is_expected.to use_before_action(:load_dish) }
    it { is_expected.to use_before_action(:load_review) }
    it { is_expected.to use_before_action(:validate_current_client_is_admin_or_reviewer) }
  end

  let(:dish) { create(:dish) }

  describe 'GET #index' do
    it "assigns @reviews" do
      review = create(:review, dish: dish)
      get :index, dish_id: dish, format: :json
      expect(assigns(:reviews)).to eq([review])
    end

    it "responds with status ok" do
      get :index, dish_id: dish, format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST #create' do
    shared_examples_for "Admin user" do
      context "with valid params" do
        before(:each) do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          @review_original_count = Review.count
          @review_params = FactoryGirl.attributes_for(:review)
          post :create, { dish_id: dish, review: @review_params, format: :json }
        end

        it "Should increase the number of reviews" do
          expect(Review.count).to eq(@review_original_count + 1)
        end

        it "should increase the resource's number of reviews" do
          expect(resource.reviews.count).to eq 1
        end

        it "should increase the dish's number of reviews" do
          expect(dish.reviews.count).to eq 1
        end

        it "should respond with status created" do
          expect(response).to have_http_status(:created)
        end
      end

      context "with invalid params" do
        it "shouldn't create a review when basic auth is not passed" do
          expect {
            post :create, { dish_id: dish, review: @review_params, format: :json }
          }.not_to change(Review, :count)
        end

        it "should respond with status unauthorized" do
          post :create, { dish_id: dish, review: @review_params, format: :json }
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
    let(:review) { create(:review) }
    it "assigns @review" do
      get :show, dish_id: dish, id: review
      expect(assigns(:review)).to eq(review)
    end

    it "responds with status ok" do
      get :show, { dish_id: dish, id: review, format: :json }
      expect(response).to have_http_status :ok
    end
  end

  describe 'PATCH #update' do
    shared_examples_for "Client" do

      context "with valid params" do
        before :each do
          @review = create(:review, rating: 5, content: "Awesome dish", reviewer: reviewer, dish: dish)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          patch :update, dish_id: dish, id: @review, format: :json,
              review: { rating: 1, content: "Awful dish" }
        end

        it "should assign @review" do
          expect(assigns(:review)).to eq(@review)
        end

        it "should change review attributes" do
          @review.reload
          expect(@review.rating).to eq(1)
          expect(@review.content).to eq('Awful dish')
        end

        it "should respond with ok" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        before :each do
          @review = create(:review, rating: 5, content: "Awesome dish", reviewer: reviewer, dish: dish)
        end

        it "shouldn't update a review when basic auth is not passed" do
          expect {
            patch :update, { id: @review, dish_id: dish, review: attributes_for(:review), format: :json }
          }.not_to change(@review, :rating)
          expect {
            patch :update, { id: @review, dish_id: dish, review: attributes_for(:review), format: :json }
          }.not_to change(@review, :content)
        end

        it "should respond with status unauthorized" do
          patch :update, { id: @review, dish_id: dish, review: attributes_for(:review), format: :json }
          expect(response).to have_http_status :unauthorized
        end

        it "should respond with not found when the given id is not found in the database" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          patch :update, { id: 5000, dish_id: dish, review: attributes_for(:review), format: :json }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "with admin" do
      let(:resource) { create(:admin) }
      let(:reviewer) { create(:user) }

      it_behaves_like "Client"
    end

    context "with user" do
      let(:resource) { create(:user) }
      let(:reviewer) { resource }

      it_behaves_like "Client"

      describe "User can't update a review that wasn't created by him/her" do
        before :each do
          @review = create(:review, reviewer: create(:admin), dish: dish, rating: 5)
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
        end

        it "should not update the review attributes" do
          expect {
            patch :update, { id: @review, dish_id: dish, review: attributes_for(:review), format: :json }
          }.not_to change(@review, :rating)
          expect {
            patch :update, { id: @review, dish_id: dish, review: attributes_for(:review), format: :json }
          }.not_to change(@review, :content)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    shared_examples_for "Client" do

      context "with valid params" do
        before :each do
          @review = create(:review, dish: dish, reviewer: reviewer)
          @review_original_count = Review.count
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          delete :destroy, id: @review, dish_id: dish, format: :json
        end

        it "should assign @review" do
          expect(assigns(:review)).to eq(@review)
        end

        it "should change dish count" do
          expect(Review.count).to eq(@review_original_count - 1)
        end

        it "should respond with ok" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        before :each do
          @review = create(:review, dish: dish, reviewer: reviewer)
          @review_original_count = Review.count
        end

        it "shouldn't delete a review when basic auth is not passed" do
          expect {
            delete :destroy, { id: @review, dish_id: dish, format: :json }
          }.not_to change(Review, :count)
        end

        it "should respond with status unauthorized" do
          delete :destroy, { id: @review, dish_id: dish, format: :json }
          expect(response).to have_http_status :unauthorized
        end

        it "should respond with not found when the given id is not found in the database" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
          delete :destroy, { id: 5000, dish_id: dish, format: :json }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "with admin" do
      let(:resource) { create(:admin) }
      let(:reviewer) { create(:user) }

      it_behaves_like "Client"
    end

    context "with user" do
      let(:resource) { create(:user) }
      let(:reviewer) { resource }

      it_behaves_like "Client"

      describe "User can't delete a review that wasn't created by him/her" do
        before :each do
          @review = create(:review, dish: dish, reviewer: create(:admin))
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.
              encode_credentials(resource.email, resource.password)
        end

        it "should not delete @review" do
          expect {
            delete :destroy, { id: @review, dish_id: dish, format: :json }
          }.not_to change(Review, :count)
        end
      end
    end
  end
end
