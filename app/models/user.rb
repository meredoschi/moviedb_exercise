# frozen_string_literal: true

# Devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable

  # By default not registerable or recoverable (this is just a demonstration)

  devise :database_authenticatable, :rememberable, :validatable

  has_many :ratings, dependent: :destroy
  has_many :movies, dependent: :destroy
end
