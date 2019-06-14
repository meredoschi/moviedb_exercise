# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/show', type: :view do

  let(:sample_title) { "Title+ "+Random.rand(100_000).to_s }

  before(:each) do

    @movie = assign(:movie, Movie.create!(
                              title:  sample_title,
                              summary: 'My movie summary text',
                              category_id: 1,
                              user_id: 1
                            ))

  end

  it 'displays the movie summary text' do
    render
    expect(rendered).to include('My movie summary text')
  end
end
