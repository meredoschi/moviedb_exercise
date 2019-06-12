# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ratings/index', type: :view do
  let(:first_rating) { FactoryBot.create(:rating) }
  let(:second_rating) { FactoryBot.create(:rating) }
  let(:ratings_arr) { [first_rating, second_rating] }

  before(:each) do
    assign(:ratings, Kaminari.paginate_array(ratings_arr).page(1))
  end

  it 'Movie title and user email are displayed' do
    render
    assert_select 'tr>td', text: first_rating.user.email
    assert_select 'tr>td', text: second_rating.movie.title
  end
end
