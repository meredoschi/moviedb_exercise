# frozen_string_literal: true

# Movie genres
class Category < ApplicationRecord
  has_many :movies, dependent: :restrict_with_exception
  validates :name, uniqueness: { case_sensitive: false }
end
