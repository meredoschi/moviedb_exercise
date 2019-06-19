# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Categories', type: :feature do
  let(:name) { Faker::Company.unique.industry + Random.rand(100_000).to_s }

  let!(:user) { FactoryBot.create(:user, admin: true) } # admin

  context 'Site administrator' do
    before(:each) do
      # Sign-in
      @user = user
      login_as(@user, scope: :user)
    end

    context 'create new category' do
      scenario 'should be succesful' do
        # category_name=Faker::Company.unique.industry+Random.rand(100_000).to_s

        visit new_category_path
        within('form') do
          fill_in 'Name', with: name
        end

        click_button 'Confirm'
        expect(page).to have_content name
        expect(page).to have_content 'Category was successfully created'
      end

      scenario 'should fail when name is missing' do
        visit new_category_path

        click_button 'Confirm'
        expect(page).to have_content 'Name can\'t be blank'
      end
    end

    context 'Confirm' do
      let!(:category) { Category.create(name: name) }
      before(:each) do
        visit edit_category_path(category)
      end

      scenario 'should be succesful' do
        within('form') do
          fill_in 'Name', with: name
        end

        click_button 'Confirm'
        expect(page).to have_content name
        expect(page).to have_content 'Category was successfully updated'
      end

      scenario 'creating is blocked if name is left blank' do
        within('form') do
          fill_in 'Name', with: ''
        end

        click_button 'Confirm'
        expect(page).to have_content 'Name can\'t be blank'
      end
    end
  end
end
