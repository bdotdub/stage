def register_app
  
  get '/' do
    haml :index
  end

  get '/:page' do
    @page = params[:page]

    if File.exists?(Sinatra.application.options.views + "/#{@page}.haml")
      # Render the page
      haml @page.to_sym
    else
      # Not found!
      raise Sinatra::NotFound
    end
  end
  
  get '/stylesheets/:sheet.css' do
    @sheet = params[:sheet]

    if File.exists?(Sinatra.application.options.views + "/#{@sheet}.sass")
      # Render the page
      content_type 'text/css', :charset => 'utf-8'
      sass @sheet.to_sym
    else
      # Not found!
      raise Sinatra::NotFound
    end
  end


end