# frozen_string_literal: true

# Films
class Movie < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many   :ratings, dependent: :destroy

  delegate :name, to: :category, prefix: true

end
