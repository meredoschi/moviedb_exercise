# frozen_string_literal: true

require 'rails_helper'

# https://codingdaily.wordpress.com/2011/09/16/rails-kaminari-with-rspec/
# https://stackoverflow.com/questions/7080335/rspec-test-broken-by-pagination-kaminari
RSpec.describe 'movies/index', type: :view do
  let(:first_movie) { FactoryBot.create(:movie) }
  let(:second_movie) { FactoryBot.create(:movie) }
  let(:movies_arr) { [first_movie, second_movie] }

  before(:each) do
    assign(:movies, Kaminari.paginate_array(movies_arr).page(1))
  end

  it 'movie titles are rendered' do
    render
    #    assert_select 'tr>td', text: first_movie.title   # Traditional rails
    #    assert_select 'tr>td', text: second_movie.title  #     "         "
    assert_select 'tr>td', text: '{{ movie.title }}' # vuejs
  end

  it 'summary is rendered (for each movie)' do
    render
    #    assert_select 'tr>td', text: first_movie.summary
    #    assert_select 'tr>td', text: second_movie.summary
    assert_select 'tr>td', text: '{{ movie.summary }}' # vuejs
  end

  it 'rendered html text contains v-model selected_category' do
    render
    expect(rendered).to include('v-model="selected_category"')
  end

  it 'rendered html text contains v-model selected_rating' do
    render
    expect(rendered).to include('v-model="selected_rating"')
  end

  it 'rendered html text contains v-model search_summary_txt' do
    render
    expect(rendered).to include('v-model="search_summary_txt"')
  end
end
