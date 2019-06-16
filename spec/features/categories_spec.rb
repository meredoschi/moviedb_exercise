# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Categories', type: :feature do
  let(:name) { Faker::Company.unique.industry + Random.rand(100_000).to_s }

  context 'Site administrator' do
    before(:each) do
      visit '/users/sign_in'

      within('form') do
        fill_in 'Email', with: 'admin@example.com'
        fill_in 'Password', with: 'samplepass'
      end

      click_on 'Log in'
    end

    context 'create new category' do
      scenario 'should be succesful' do
        # category_name=Faker::Company.unique.industry+Random.rand(100_000).to_s

        visit new_category_path
        within('form') do
          fill_in 'Name', with: name
        end

        click_button 'Create Category'
        expect(page).to have_content name
        expect(page).to have_content 'Category was successfully created'
      end

      scenario 'should fail when name is missing' do
        visit new_category_path

        click_button 'Create Category'
        expect(page).to have_content 'Name can\'t be blank'
      end
    end

    context 'update category' do
      let!(:category) { Category.create(name: name) }
      before(:each) do
        visit edit_category_path(category)
      end

      scenario 'should be succesful' do
        within('form') do
          fill_in 'Name', with: name
        end

        click_button 'Update Category'
        expect(page).to have_content name
        expect(page).to have_content 'Category was successfully updated'
      end

      scenario 'creating is blocked if name is left blank' do
        within('form') do
          fill_in 'Name', with: ''
        end

        click_button 'Update Category'
        expect(page).to have_content 'Name can\'t be blank'
      end
    end

    context 'Destroy a category' do
      scenario 'should be succesful' do
        visit categories_path
        accept_confirm do
          first(:link, 'Destroy').click
        end
        expect(page).to have_content 'Category was successfully destroyed'
      end
    end
  end
end
