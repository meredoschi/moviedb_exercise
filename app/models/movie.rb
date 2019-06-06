# frozen_string_literal: true

# Films
class Movie < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many   :ratings, dependent: :destroy

  delegate :name, to: :category, prefix: true

#   def as_json(options={})
#     super(:include => {:category => {:only => [:name]}})
#  end


  def self.detailed_info
    movie_list = []
    movies = Movie.all
    movies.each do |movie|
      movie_info = movie.attributes
      movie_info[:category_name] = movie.category_name
      movie_list << movie_info
    end
    movie_list
  end

  # Instance methods
  def info
    [title, summary, category_name, id, category_id].reject(&:blank?).join(' ')
  end

end
