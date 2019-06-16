# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Movies', type: :feature, js: true do
  let(:sample_name) { Faker::Name.prefix + ' ' + Faker::Name.last_name }

  let(:verb) { Faker::Verb.unique.past_participle }
  let(:title) { sample_name + ' ' + verb + ' ' + Faker::Internet.email.to_s }
  let!(:movie) { FactoryBot.create(:movie) }

  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  context 'logged in users' do
    # Sign-in
    before(:each) do
      @user = FactoryBot.create(:user)
      login_as(@user, scope: :user)
    end

    context 'CREATE' do
      scenario 'able to create new (provided complete data given)' do
        category_name = Category.first.name

        visit new_movie_path

        within('form') do
          fill_in 'Title', with: title
          fill_in 'Summary', with: title + verb
        end

        select(category_name, from: 'Category')
        click_button 'Create Movie'
        expect(page).to have_content title
      end

      scenario 'creation is blocked if attributes are left blank (Title, Summary, Category)' do
        visit new_movie_path

        #      within('form') do
        #        fill_in 'Title', with: ''
        #      end

        click_button 'Create Movie'
        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Category must exist'
        expect(page).to have_content 'Summary can\'t be blank'
        expect(page).to have_content 'prohibited this movie from being saved:'
      end

      scenario 'creation is blocked if title is missing' do
        visit new_movie_path

        click_button 'Create Movie'
        expect(page).to have_content 'Title can\'t be blank'
      end

      scenario 'creation is blocked (category must be selected)' do
        visit new_movie_path

        within('form') do
          fill_in 'Title', with: title
          fill_in 'Summary', with: title + verb
        end

        click_button 'Create Movie'
      end
    end

    context 'UPDATE' do
      scenario 'able to update own movie' do
        movie.user_id = @user.id # make it its own (for testing purposes)
        movie.save

        visit edit_movie_path(movie)

        within('form') do
          fill_in 'Title', with: 'some new title ' + title
        end

        click_button 'Update Movie'
        expect(page).to have_content 'some new title ' + title
        expect(page).to have_content 'Movie was successfully updated'
      end

      pending 'unable to update someone else\'s movie' do
        visit edit_movie_path(movie)

        within('form') do
          fill_in 'Title', with: 'some new title ' + title
        end

        click_button 'Update Movie'
        expect(page).to raise_error(CanCan::AccessDenied)
      end
    end
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
#     scenario 'creation should fail when name is missing' do
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
