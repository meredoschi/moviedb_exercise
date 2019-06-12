# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /movies' do
    it 'works! (now write some real specs)' do
      sign_in user
      get movies_path
      expect(response).to have_http_status(200)
    end
  end
end
