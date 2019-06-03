# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { is_expected.to belong_to(:category) }

  it 'can be created' do
    FactoryBot.create(:movie)
  end

  it 'five can be created' do
    FactoryBot.create_list(:movie, 5)
  end
end
