# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ratings', type: :request do
  describe 'GET /ratings' do
    let(:user) { FactoryBot.create(:user) }

    it 'works! (now write some real specs)' do
      sign_in user
      get ratings_path
      expect(response).to have_http_status(200)
    end
  end
end
