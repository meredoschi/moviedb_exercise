# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'categories/index', type: :view do
  let(:sample_name) { Random.rand(100_000).to_s + Faker::Company.unique.industry }
  let(:sample_name2) { sample_name + '2' }

  let(:first_category) { FactoryBot.create(:category) }
  let(:second_category) { FactoryBot.create(:category) }
  let(:categories_arr) { [first_category, second_category] }

  before(:each) do
    assign(:categories, Kaminari.paginate_array(categories_arr).page(1))
  end

  it 'names are displayed' do
    render
    assert_select 'tr>td', text: first_category.name
    assert_select 'tr>td', text: second_category.name
  end
end
