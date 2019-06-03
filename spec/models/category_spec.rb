# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:movies) }
  it { is_expected.to have_db_index(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it 'can be created' do
    FactoryBot.create(:category)
  end

  it 'five can be created' do
    FactoryBot.create_list(:category, 5)
  end
end
