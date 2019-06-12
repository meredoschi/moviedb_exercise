# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/show', type: :view do
  before(:each) do
    @movie = assign(:movie, Movie.create!(
                              title: 'Title',
                              summary: 'MyText',
                              category_id: 2,
                              user_id: 1
                            ))

    # https://stackoverflow.com/questions/19641117/views-testing-and-devises-current-user/19641413
    allow(view).to receive(:user_signed_in?) { true }

  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
#    expect(rendered).to match(/2/)
  end
end
