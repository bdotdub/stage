require 'rubygems'
require 'sinatra/lib/sinatra.rb'

require 'stage/helpers'
require 'stage/handlers'

require 'stage/app'

register_handlers
register_helpers

register_app

use_in_file_templates!
