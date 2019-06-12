# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Movies', type: :feature do
  let(:sample_name) { Faker::Name.prefix + ' ' + Faker::Name.last_name }
  let(:verb) { Faker::Verb.unique.past_participle }
  let(:title) { sample_name + ' ' + verb + ' ' + Faker::Internet.email.to_s }

  context 'logged in users' do
    # Sign-in

    before(:each) do
      visit '/users/sign_in'
      assert page.has_content?('Log in')

      within('form') do
        fill_in 'Email', with: 'sample@example.com'
        fill_in 'Password', with: 'samplepass'
      end

      click_button 'Log in'

      visit new_movie_path

      assert page.has_content?('New Movie')
    end

    scenario 'able to create new (provided complete data given)' do
      category_name = Category.first.name

      within('form') do
        fill_in 'Title', with: title
        fill_in 'Summary', with: title
      end

      select(category_name, from: 'Category')

      #      find('select#movie_id').find("option[value='#{category_name}']").select_option

      click_button 'Create Movie'
      expect(page).to have_content title
      expect(page).to have_content 'Movie was successfully created'
    end

    scenario 'creation is blocked (category must be selected)' do
      within('form') do
        fill_in 'Title', with: title
        fill_in 'Summary', with: title
      end

      click_button 'Create Movie'
      expect(page).to have_content title
      expect(page).to have_content 'Category must exist'
    end
  end

  #
  #   context 'create new movie' do
  #     scenario 'should be succesfull' do
  #
  #       visit new_movie_path
  #       within('form') do
  #         fill_in 'Name', with: name
  #       end
  #
  #       click_button 'Create movie'
  #       expect(page).to have_content name
  #       expect(page).to have_content 'movie was successfully created'
  #     end
  #
  #     scenario 'should fail when name is missing' do
  #       visit new_movie_path
  #
  #       click_button 'Create movie'
  #       expect(page).to have_content 'Name can\'t be blank'
  #     end
  #   end
  #
  #   context 'update movie' do
  #     let!(:movie) { movie.create(name: name) }
  #     before (:each) do
  #       visit edit_movie_path(movie)
  #     end
  #
  #     scenario 'should be succesfull' do
  #       within('form') do
  #         fill_in 'Name', with: name
  #       end
  #
  #       click_button 'Update movie'
  #       expect(page).to have_content name
  #       expect(page).to have_content 'movie was successfully updated'
  #     end
  #
  #     scenario 'should fail if name is blanked' do
  #       within('form') do
  #         fill_in 'Name', with: ''
  #       end
  #
  #       click_button 'Update movie'
  #       expect(page).to have_content 'Name can\'t be blank'
  #     end
  #   end
  #
  #   context 'The first destroy button in the page' do
  #     scenario 'should be succesfull' do
  #
  #       destroy_links=find_all(:link, "Destroy")
  #
  #       destroy_links.first.click
  #
  #       expect(page).to have_content 'movie was successfully destroyed'
  #
  #     end
  #   end
  #
end
