$:.unshift 'vendor/sinatra/lib'
$:.unshift 'vendor/rack-cache/lib'

require 'sinatra'
require 'rack/cache'

require 'rubygems'

use Rack::Cache do
  set :verbose, true
end

require 'stage.rb'
run Stage

