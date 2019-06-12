# frozen_string_literal: true

# Movie genres
class Category < ApplicationRecord
  has_many :movies, dependent: :nullify
  validates :name, uniqueness: { case_sensitive: false }
  validates_presence_of :name

end
