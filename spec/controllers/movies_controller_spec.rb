# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do

  let(:attr) do
    { title: 'new title', summary: 'new text', category_id: 1, user_id: 1 }
  end 

  context '#GET index' do
    it 'responds with success' do
      get :index
      expect(response).to be_successful
    end
  end

  context '#GET show' do
    it 'responds with success' do
      @movie = FactoryBot.create(:movie)
      get :show, params: { id: @movie.to_param }
      expect(response).to be_successful
    end
  end

  context '#POST update' do
    context 'with valid data' do
      before(:each) do
        @movie = FactoryBot.create(:movie)
        put :update, params: { id: @movie.id, movie: attr }
        @movie.reload
      end

      it 'redirects to the show view' do
        expect(response).to redirect_to(@movie)
      end

      it 'updates title attribute' do
        expect(@movie.title).to eql attr[:title]
      end

      it 'updates summary attribute' do
        expect(@movie.summary).to eql attr[:summary]
      end

      it 'updates the category_id attribute' do
        expect(@movie.category_id).to eql attr[:category_id]
      end
    end
  end
  context 'JSON' do
    it 'GET returns the expect key signature' do
      get :index, format: :json
      key_signature = %w[id title summary created_at updated_at user_id category ratings]
      parsed_response = JSON.parse(response.body)
      expect(parsed_response[0].keys).to eq(key_signature)
    end
  end

  context 'Logged in users' do
    # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end

    context 'POST #create' do
      it 'create a new movie' do
        expect { post(:create, params: { movie: attr }) }.to change(Movie, :count).by(1)
      end
    end

    context 'DELETE #destroy' do
      let!(:movie) { create :movie }

      it 'should delete movie' do
        expect { delete :destroy, params: { id: movie.id } }.to change(Movie, :count).by(-1)
      end
    end
  end
end
