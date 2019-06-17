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

    (num_ratings.zero?) ? 0 : (stars_total*1.0 / num_ratings)

  end

  def rated?

    (num_ratings > 0)

  end

  def genre
      category.name if category.present?
  end
end
