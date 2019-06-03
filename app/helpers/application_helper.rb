# frozen_string_literal: true

module ApplicationHelper
  # Adapted from Ruby on Rails 3 Tutorial, p. 121
  def title
    base_title = Settings.application_name
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
