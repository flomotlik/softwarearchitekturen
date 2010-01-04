# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SoftwareArchitekturen_session',
  :secret      => 'e915357f175dee6600ab0526b68354ecf4269e98fc7242fb5a307cd151445b8ccf13e1477bb7082a498e177f44063ff0473bbd75701433056a6fa05812b602ef'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
