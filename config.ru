$:.unshift 'vendor/sinatra/lib'
$:.unshift 'vendor/rack-cache/lib'

require 'sinatra'
require 'rack/cache'

require 'rubygems'

use Rack::Cache do
  set :verbose, true
end
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :raise_errors => true,
  :views => File.dirname(__FILE__) + '/views'
)

log = File.new('logs/stage.out', 'a')
error_log = File.new('logs/stage.err', 'a')

STDOUT.reopen(log)
STDERR.reopen(error_log)

require 'stage.rb'
run Sinatra.application

