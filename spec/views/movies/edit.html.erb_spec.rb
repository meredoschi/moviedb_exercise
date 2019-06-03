# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/edit', type: :view do
  before(:each) do
    sample_name = Random.rand(100_000).to_s + Faker::Company.unique.industry

    sample_title = Faker::Name.unique.last_name + ' ' + Faker::Verb.unique.past_participle

    @category = assign(:category, Category.create!(
                                    name: sample_name
                                  ))

    @movie = assign(:movie, Movie.create!(
                              title: sample_title,
                              summary: 'MyText',
                              category_id: @category.id
                            ))
  end
  it 'renders the edit movie form' do
    render

    assert_select 'form[action=?][method=?]', movie_path(@movie), 'post' do
      assert_select 'input[name=?]', 'movie[title]'

      assert_select 'textarea[name=?]', 'movie[summary]'

      assert_select 'input[name=?]', 'movie[category_id]'
    end
  end
end
