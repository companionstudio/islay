require 'rails-observers'
require 'cells'
require 'cells-rails'
require 'hamlit'
require 'cells-hamlit'
# require 'compass-rails' # This is temporary. By rights this needs to go into the assets group
require 'sass-rails'
require 'jquery-rails'
require 'devise'
require 'devise_invitable'
require 'cancancan'
require 'simple_form'
require 'pg'
require 'pg_search'
require 'friendly_id'
require 'fog-aws'
require 'mime/types'
require 'streamio-ffmpeg'
# require 'zipruby'
require 'jsonify-rails'
require 'kaminari'
require 'rmagick'
require 'rdiscount'
require 'acts_as_list'
require 'draper'
require 'premailer'

require "core_ext/active_record/querying"

require "islay/engines"
require "islay/engine"
require "islay/core_ext"
require "islay/coercion"
require "islay/form_builder"
require "islay/active_record"
require "islay/positioning"
require "islay/publishable"
require "islay/metadata"
require "islay/taggable"
require "islay/query"
require "islay/configuration"
require "islay/extensions"
require "islay/navigation"
require "islay/pages"
require "islay/resourceful_controller"
require "islay/sprockets"
require "islay/routing_mapper_helpers"

module Islay
end
