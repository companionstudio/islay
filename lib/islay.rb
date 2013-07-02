require 'cells'
require 'haml'
require 'sass-rails'
require 'jquery-rails'
require 'compass-rails' # This is temporary. By rights this needs to go into the assets group
require 'devise'
require 'simple_form'
require 'pg'
require 'schema_plus'
require 'activerecord-postgres-hstore'
require 'fog'
require 'girl_friday'
require 'mime/types'
require 'streamio-ffmpeg'
require 'zipruby'
require 'jsonify-rails'
require 'kaminari'
require 'RMagick'
require 'acts_as_list'
require 'hierarchy'
require 'draper'
require 'premailer'

require "islay/engine"
require "islay/core_ext"
require "islay/coercion"
require "islay/form_builder"
require "islay/active_record"
require "islay/positioning"
require "islay/publishable"
require "islay/metadata"
require "islay/taggable"
require "islay/searches"
require "islay/query"
require "islay/extensions"
require "islay/pages"
require "islay/resourceful_controller"
require "islay/sprockets"
require "islay/routing_mapper_helpers"

module Islay
end
