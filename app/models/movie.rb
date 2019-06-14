# frozen_string_literal: true

# Films
class Movie < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many   :ratings, dependent: :destroy

  delegate :name, to: :category, prefix: true

  def num_ratings
    ratings.count
  end

  def stars_total
    ratings.sum(:stars)
  end

  # average rating
  def stars
    stars_total / num_ratings
  end
end
