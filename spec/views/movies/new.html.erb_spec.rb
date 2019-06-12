# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'movies/new', type: :view do
  before(:each) do
    assign(:movie, Movie.new(
                     title: 'MyString',
                     summary: 'MyText',
                     category_id: 1
                   ))

                   # https://stackoverflow.com/questions/19641117/views-testing-and-devises-current-user/19641413
                   allow(view).to receive(:user_signed_in?) { true }
  end

  it 'renders new movie form' do
    render

    assert_select 'form[action=?][method=?]', movies_path, 'post' do
      assert_select 'input[name=?]', 'movie[title]'

      assert_select 'textarea[name=?]', 'movie[summary]'

#      assert_select 'input[name=?]', 'movie[category_id]'
    end
  end
end
