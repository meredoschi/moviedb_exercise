# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/show', type: :view do
  let(:sample_title) { 'Title+ ' + Random.rand(100_000).to_s }

  let!(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category) }

  before(:each) do
    @movie = assign(:movie, Movie.create!(
                              title: sample_title,
                              summary: 'My movie summary text',
                              category_id: category.id,
                              user_id: user.id
                            ))
  end

  it 'displays the movie summary text' do
    render
    expect(rendered).to include('My movie summary text')
  end
end
