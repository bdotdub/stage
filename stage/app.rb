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


end