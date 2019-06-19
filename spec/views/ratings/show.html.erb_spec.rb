# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ratings/show', type: :view do
  before(:each) do
    #    @rating = assign(:rating, Rating.create(movie_id: 1, user_id: 1, stars:5))
    @rating = assign(:rating, FactoryBot.create(:rating))
  end

  it 'renders Movie Title and stars awarded' do
    render
    expect(rendered).to match(@rating.movie.title)
    expect(rendered).to match(@rating.stars.to_s)
  end
end
