# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'categories/edit', type: :view do
  sample_name = Random.rand(100_000).to_s + Faker::Company.unique.industry
  before(:each) do
    @category = assign(:category, Category.create!(
                                    name: sample_name
                                  ))
  end

  it 'renders the edit category form' do
    render

    assert_select 'form[action=?][method=?]', category_path(@category), 'post' do
      assert_select 'input[name=?]', 'category[name]'
    end
  end
end
