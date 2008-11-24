ENV['GEM_PATH'] = '/home/benny/.gems'

require 'rubygems'
require 'sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :raise_errors => true,
  :views => File.dirname(__FILE__) + '/views'
)

log = File.new('logs/sinatra.out', 'a')
error_log = File.new('logs/sinatra.err', 'a')

STDOUT.reopen(log)
STDERR.repoen(error_log)

require 'stage.rb'
run Sinatra.application

