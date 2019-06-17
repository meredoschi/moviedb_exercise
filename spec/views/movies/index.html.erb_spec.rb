# frozen_string_literal: true

require 'rails_helper'

# https://codingdaily.wordpress.com/2011/09/16/rails-kaminari-with-rspec/
# https://stackoverflow.com/questions/7080335/rspec-test-broken-by-pagination-kaminari
RSpec.describe 'movies/index', type: :view, js: true do
  let(:first_movie) { FactoryBot.create(:movie) }
  let(:second_movie) { FactoryBot.create(:movie) }
  let(:movies_arr) { [first_movie, second_movie] }

  before(:each) do
    assign(:movies, Kaminari.paginate_array(movies_arr).page(1))
  end

  it '"Movie list" heading is displayed' do
    render
    expect(rendered).to include('Movie list')
  end

  pending 'rendered html text contains v-model selected_category' do
    render
    expect(rendered).to include('v-model="selected_category"')
  end

  pending 'rendered html text contains v-model selected_rating' do
    render
    expect(rendered).to include('v-model="selected_rating"')
  end

  pending 'rendered html text contains v-model search_summary_txt' do
    render
    expect(rendered).to include('v-model="search_summary_txt"')
  end
end
