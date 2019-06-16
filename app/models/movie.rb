# frozen_string_literal: true

# Films
class Movie < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many   :ratings, dependent: :destroy

  delegate :name, to: :category, prefix: true

  validates :title, presence: true
  validates :summary, presence: true

  def num_ratings
    ratings.count
  end

  def stars_total
    ratings.sum(:stars)
  end

  # average rating
  def stars
    if num_ratings.zero?
      0
    else
      stars_total / num_ratings
    end
  end

  def rated?

    is_rated=false

    if num_ratings > 0
      is_rated=true
    end

    is_rated
  end
end
