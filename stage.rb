require 'rubygems'
require 'sinatra'

require 'stage/helpers'
require 'stage/handlers'

require 'stage/app'

register_handlers
register_helpers

register_app

use_in_file_templates!
