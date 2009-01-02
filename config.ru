require 'sinatra/lib/sinatra.rb'
require 'rubygems'
 
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

