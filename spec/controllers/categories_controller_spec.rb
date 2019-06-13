# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  context '#GET index' do
    it 'responds with success' do
      get :index
      expect(response).to be_success
    end
  end

  context '#GET show' do
    it 'responds with success' do
      category = FactoryBot.create(:category)
      get :show, params: { id: category.to_param }
      expect(response).to be_success
    end
  end
end
