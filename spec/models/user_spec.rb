# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  # Associations

  it { is_expected.to have_many(:ratings) }

  # Validations

  # Class methods

  # Instance methods
end
