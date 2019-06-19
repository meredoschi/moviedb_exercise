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

    context 'Script' do
      scenario 'Has a show button' do
        visit movies_path
        expect(page).to have_button('Show')
      end

      scenario 'able to remove own movie' do
        category_name = Category.first.name

        visit new_movie_path

        within('form') do
          fill_in 'Title', with: title
          fill_in 'Summary', with: title + verb
        end

        select(category_name, from: 'Category')
        click_button 'Confirm'

        visit movies_path
        page.accept_confirm do
          click_button 'Remove'
        end
      end

      scenario 'Create new movie, increasing the movie count by 1, able to edit it
         (due to being its owner) and the updated title appears on the list (index view)' do

        category_name = Category.first.name

        # Since pagination is in effect, ensure it is first on the list, thus appearing on the page
        a_title = 'AAAAAAAAAAAAAAAA'

        initial_num_movies = Movie.count

        visit new_movie_path

        within('form') do
          fill_in 'Title', with: title
          fill_in 'Summary', with: title + verb
        end

        select(category_name, from: 'Category')
        click_button 'Confirm'

        current_num_movies = Movie.count

        expect(current_num_movies).to eq(initial_num_movies + 1)

        visit movies_path
        click_button 'Edit'

        fill_in 'Title', with: a_title
        click_button 'Confirm'

        visit movies_path
        expect(page).to have_content a_title
      end

      # script context ends
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
        click_button 'Confirm'
        expect(page).to have_content title
      end

      scenario 'creation is blocked if attributes are left blank (Title, Summary, Category)' do
        visit new_movie_path

        #      within('form') do
        #        fill_in 'Title', with: ''
        #      end

        click_button 'Confirm'
        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Category must exist'
        expect(page).to have_content 'Summary can\'t be blank'
        expect(page).to have_content 'prohibited this movie from being saved:'
      end

      scenario 'creation is blocked if title is missing' do
        visit new_movie_path

        click_button 'Confirm'
        expect(page).to have_content 'Title can\'t be blank'
      end

      scenario 'creation is blocked (category must be selected)' do
        visit new_movie_path

        within('form') do
          fill_in 'Title', with: title
          fill_in 'Summary', with: title + verb
        end

        click_button 'Confirm'
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

        click_button 'Confirm'
        expect(page).to have_content 'some new title ' + title
        expect(page).to have_content 'Movie was successfully updated'
      end

      pending 'unable to update someone else\'s movie' do
        visit edit_movie_path(movie)

        within('form') do
          fill_in 'Title', with: 'some new title ' + title
        end

        click_button 'Confirm'
        expect(page).to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
