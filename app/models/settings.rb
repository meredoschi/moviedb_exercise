# frozen_string_literal: true

# https://github.com/settingslogic/settingslogic
class Settings < Settingslogic
  source Rails.root.join('config', 'application_settings.yml')
  namespace Rails.env
end
