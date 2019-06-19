# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let!(:movie) { FactoryBot.create(:movie) }
  let!(:second_movie) { FactoryBot.create(:movie) }

  let(:attr) do
    #    { title: 'new title', summary: 'new text', category_id: 1, user_id: 1 }
    { title: movie.title, summary: movie.summary, category_id: movie.category.id,
      user_id: movie.user.id }
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

  context 'JSON' do
    it 'GET returns the expect key signature' do
      get :index, format: :json
      key_signature = %w[id title summary created_at updated_at user_id
                         genre num_ratings stars category ratings]
      parsed_response = JSON.parse(response.body)
      expect(parsed_response[0].keys).to eq(key_signature)
    end
  end

  context 'Logged in users' do
    # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]

      user = FactoryBot.create(:user)
      @own_movie = FactoryBot.create(:movie, user_id: user.id)

      another_user = FactoryBot.create(:user)
      @somebody_elses_movie = FactoryBot.create(:movie, user_id: another_user.id)
      @somebody_elses_movie = FactoryBot.create(:movie, user_id: another_user.id)

      sign_in user
    end

    context 'POST #create' do
      it 'create a new movie' do
        expect { post(:create, params: { movie: attr }) }.to change(Movie, :count).by(1)
      end
    end

    context '#POST update' do
      context 'own movie' do
        before(:each) do
          @movie = @own_movie
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

      #       context 'somebody_elses_movie' do
      #         before(:each) do
      #
      #           put :update, params: { id: @somebody_elses_movie.id, movie: attr }
      #           @somebody_elses_movie.reload
      #         end
      #
      #         it 'unable to update someone else\'s movie (ability, access denied)' do
      #           expect(response).to raise_error(CanCan::AccessDenied)
      #            expect(response).to raise_error
      #
      #         end
      #       end
      #
    end

    context 'DELETE #destroy' do
      let!(:movie) { create :movie }

      it 'able to delete own movie' do
        expect { delete :destroy, params: { id: @own_movie.id } }.to change(Movie, :count).by(-1)
      end

      it 'unable to delete another person\'s movie (restricted by ability, access denied)' do
        # expect { delete :destroy,
        #          params: { id: @somebody_elses_movie.id } }.to raise_error(CanCan::AccessDenied)
        expect { delete :destroy, params: { id: @somebody_elses_movie.id } }.to raise_error
      end
    end
  end
end
