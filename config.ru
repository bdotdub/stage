ENV['GEM_PATH'] = '/home/benny/.gems'

require 'rubygems'
require 'sinatra'
 
Sinatra::Application.default_options.merge!(
   :run => false,
   :env => :production
)
      
require 'stage.rb'
run Sinatra.application

