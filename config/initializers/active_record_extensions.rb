Rails.application.config.to_prepare do
  # Load Islay ActiveRecord extensions
  require_dependency 'islay/active_record'
end
