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
      movie = FactoryBot.create(:movie)
      get :show, params: { id: movie.to_param }
      expect(response).to be_successful
    end
  end

  context '#POST update' do
    before(:each) do
      @movie = FactoryBot.create(:movie)
      put :update, params: { id: @movie.id, movie: attr }
      @movie.reload
    end

    it 'redirects to the show view' do
      puts response
      puts @movie
      expect(response).to redirect_to(@movie)
    end

    it 'updates title attribute' do
      expect(@movie.title).to eql attr[:title]
    end

    it 'updates summary attribute' do
      expect(@movie.summary).to eql attr[:summary]
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
end
