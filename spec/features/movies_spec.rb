# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Movies', type: :feature, js: true do
  let(:sample_name) { Faker::Name.prefix + ' ' + Faker::Name.last_name }

  let(:verb) { Faker::Verb.unique.past_participle }
  let(:title) { sample_name + ' ' + verb + ' ' + Faker::Internet.email.to_s }

  let!(:first_category) { FactoryBot.create(:category) }
  let!(:second_category) { FactoryBot.create(:category) }

  let!(:movie) { FactoryBot.create(:movie, category_id: first_category.id) }
  let!(:second_movie) { FactoryBot.create(:movie, category_id: second_category.id) }

  let!(:first_movie_rating) { FactoryBot.create(:rating,  movie_id: movie.id, stars: 3) }
  let!(:second_movie_rating) { FactoryBot.create(:rating, movie_id: second_movie.id, stars: 5) }

  let(:no_records_found_message) { 'No records found with the selected search criteria.' }

  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  context 'logged in users' do
    # Sign-in
    before(:each) do
      @user = FactoryBot.create(:user)
      login_as(@user, scope: :user)
    end

    context 'Script' do
      scenario 'Search by text is consistent' do
        visit movies_path
        expect(page).not_to have_content(no_records_found_message)
        fill_in 'search_text', with: 'xyz12345'
        expect(page).to have_content(no_records_found_message)
        chars = movie.summary[0..5]
        fill_in 'search_text', with: chars
        expect(page).to have_content(chars)
      end

      scenario 'Give the last movie on the list five stars' do
        visit movies_path

        initial_num_ratings = Rating.count

        # the last star on the page has index -1 (it is an svg)
        sleep 5
        page.all('svg')[-1].click
        sleep 5
        num_ratings_after_star_was_clicked = Rating.count
        
        expect((num_ratings_after_star_was_clicked - initial_num_ratings)).to eq(1)
      end

      scenario 'Filter by category' do
        visit movies_path
        expect(page).not_to have_content(no_records_found_message)

        movies_table = page.find(:css, 'table#movies-table')

        movies_table_initial_row_count = movies_table.all(:css, 'tr').size

        # find the category select button, fill in with the category name and press enter
        page.find(:css, 'div#category_select').select_option.fill_in(with:
          first_category.name).send_keys :return

        filtered_row_count = movies_table.all(:css, 'tr').size

        expect((movies_table_initial_row_count - filtered_row_count)).to eq(1)
      end

      scenario 'Filter by rating' do
        visit movies_path
        expect(page).not_to have_content(no_records_found_message)

        movies_table = page.find(:css, 'table#movies-table')

        movies_table_initial_row_count = movies_table.all(:css, 'tr').size

        # find the rating select button, fill in with the numeric stars rating and press enter
        page.find(:css, 'div#rating_select').select_option.fill_in(with:
          first_movie_rating.stars.to_s + ' Star').send_keys :return

        filtered_row_count = movies_table.all(:css, 'tr').size

        expect((movies_table_initial_row_count - filtered_row_count)).to eq(1)
      end

      scenario 'Has a show button' do
        visit movies_path
        expect(page).to have_button('Show')
      end

      it 'able to remove own movie' do
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
    end
  end
end
