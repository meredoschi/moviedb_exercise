# frozen_string_literal: true

# Ratings go from 1 to 5 stars
class Rating < ApplicationRecord
  belongs_to :movie
  belongs_to :user
end
