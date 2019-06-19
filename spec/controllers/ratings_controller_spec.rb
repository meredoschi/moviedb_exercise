# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let!(:rating) { FactoryBot.create(:rating) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:movie) { FactoryBot.create(:movie, user_id: user.id) }

  let(:attr) do
    { movie_id: rating.movie.id, stars: rating.stars, user_id: rating.user_id }
  end

  context 'Logged in users' do
    # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context '#GET index' do
      it 'responds with success' do
        get :index
        expect(response).to be_successful
      end
    end

    context '#GET show (rating created by the same user)' do
      it 'responds with success' do
        @rating = FactoryBot.create(:rating, movie_id: movie.id, user_id: user.id)
        get :show, params: { id: @rating.to_param }
        expect(response).to be_successful
      end
    end

    context 'POST #create' do
      it 'create a new rating' do
        expect { post(:create, params: { rating: attr }) }.to change(Rating, :count).by(1)
      end
    end
  end
end
