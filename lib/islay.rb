require 'haml'
require 'sass-rails'
require 'jquery-rails'
require 'compass-rails' # This is temporary. By rights this needs to go into the assets group
require 'devise'
require 'simple_form'
require 'pg'
require 'schema_plus'
require 'activerecord-postgres-hstore'
require 'carrierwave'
require 'carrierwave_backgrounder'
require 'girl_friday'
require 'mime/types'
require 'streamio-ffmpeg'
require 'zipruby'
require 'jsonify-rails'

require "islay/engine"
require "islay/coercion"
require "islay/form_builder"
require "islay/active_record"
require "islay/carrierwave"
require "islay/extensions"

# Use require dependency to get around mixins going missing
# after class reloading.
require_dependency "islay/admin_controller"
require_dependency "islay/admin_helpers"

module Islay
end
