# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending { is_expected.to have_db_index(:name) }
  pending { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it 'can be created' do
    FactoryBot.create(:category)
  end

  it 'twenty can be created' do
    FactoryBot.create_list(:category, 20)
  end
end
