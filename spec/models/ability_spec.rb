# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'
# Refer to
# https://github.com/ryanb/railscasts/blob/master/spec/models/ability_spec.rb

describe 'Ability' do
  #   describe "as guest" do
  #     before(:each) do
  #       @ability = Ability.new(nil)
  #     end
  #

  describe 'visitor' do
    it 'Able to read (view) all movies and categories' do
      user = nil
      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Movie)
      expect(ability).to be_able_to(:read, Category)
    end
  end

  describe 'as admin' do
    it 'Able to manage all' do
      user = FactoryBot.create(:user, admin: true)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:manage, :all)
    end
  end

  describe 'member' do
    it 'Able to read (view) all movies and categories' do
      user = FactoryBot.create(:user)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Movie)
      expect(ability).to be_able_to(:read, Category)
    end

    it 'Able to view their own ratings' do
      user = FactoryBot.create(:user)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:read, Rating, user_id: user.id)
    end

    it 'Able to update and remove movies they created' do
      user = FactoryBot.create(:user)
      ability = Ability.new(user)
      expect(ability).to be_able_to(%i[update destroy], Movie, user_id: user.id)
    end

    it 'Able create a new movie record' do
      user = FactoryBot.create(:user)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:create, Movie)
    end

    it 'Able to rate' do
      user = FactoryBot.create(:user)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:create, Rating)
    end
  end
end
