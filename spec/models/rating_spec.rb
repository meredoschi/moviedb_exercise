# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { FactoryBot.create(:rating) }

  # Associations

  # Validations

  # Class methods

  # Instance methods

  it { is_expected.to belong_to(:movie) }
  it { is_expected.to belong_to(:user) }

  it 'can be created' do
    FactoryBot.create(:rating)
  end

  it 'five can be created' do
    FactoryBot.create_list(:rating, 5)
  end
end
