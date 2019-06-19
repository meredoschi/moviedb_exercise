# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/edit', type: :view do
  let!(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category) }

  before(:each) do
    sample_title = Faker::Name.unique.last_name + ' ' + Faker::Verb.unique.past_participle

    @movie = assign(:movie, Movie.create!(
                              title: sample_title,
                              summary: 'My movie summary text',
                              category_id: category.id,
                              user_id: user.id
                            ))

    @category = assign(:category, category)

    # https://stackoverflow.com/questions/19641117/views-testing-and-devises-current-user/19641413
    allow(view).to receive(:user_signed_in?) { true }
    #  allow(view).to receive(:current_user) { FactoryGirl.build(:user, email 'joe@example.com') }
  end

  it 'renders the edit movie form' do
    render

    assert_select 'form[action=?][method=?]', movie_path(@movie), 'post' do
      assert_select 'input[name=?]', 'movie[title]'

      assert_select 'textarea[name=?]', 'movie[summary]'

      #    assert_select 'input[name=?]', 'movie[category_id]'
    end
  end
end
