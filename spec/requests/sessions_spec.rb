# frozen_string_literal: true

# https://github.com/plataformatec/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)
require 'rails_helper'
RSpec.describe 'Sessions' do
  let(:user) { FactoryBot.create(:user) }

  it 'signs user in' do
    sign_in user
    get root_path
    expect(response).to render_template(:index)
  end
end
