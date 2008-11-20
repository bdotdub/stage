require 'rubygems'
require 'sinatra'

get '/' do
  "Hello! It's Benny!"
end

get '/:page' do
  @page = params[:page]
  haml :page
end


