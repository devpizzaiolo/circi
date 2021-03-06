PizzaioloCa::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  
  config.cache_store = :memory_store
  config.action_controller.perform_caching = false
  
  # config.cache_store = :mem_cache_store
  

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  
  
  # Postmark Setup
  config.action_mailer.delivery_method = :test
  # config.action_mailer.default_url_options = { :host => 'pizzaiolo.ca' }
  # config.action_mailer.delivery_method   = :postmark
  # config.action_mailer.postmark_settings = { :api_key => "9d68acab-4232-465c-8fae-9a97bb599046" }
  # config.action_mailer.perform_deliveries = true

  config.action_mailer.default_url_options = { :host => 'pizzaiolo.ca' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :user_name => '59a49ef19f604a',
    :password => '6f8af86f36acb5',
    :address => 'smtp.mailtrap.io',
    :domain => 'smtp.mailtrap.io',
    :port => '2525',
    :authentication => :cram_md5
  }

  config.action_mailer.perform_deliveries = true
  

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :null
  
  # disable messagees relating to assets missing, etc...
  config.assets.logger = false
  config.assets.initialize_on_precompile = false

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false
  
end
