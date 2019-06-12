# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'categories/show', type: :view do
  sample_name = Random.rand(100_000).to_s
  before(:each) do
    @category = assign(:category, Category.create!(
                                    name: sample_name
                                  ))
  end

  it 'renders name' do
    render
    expect(rendered).to include(sample_name)
  end
end
