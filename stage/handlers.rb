class Stage < Sinatra::Base

  # Render views/404.haml
  error 404 do
    haml 'four oh four'
  end

  # Render views/500.haml
  # @e holds whatever was thrown, in this example, a string, 
  # but it could have an Error class of some sort.
  error 500 do
    @e = request.env['sinatra_error']
    haml "five hundred #{@e}"
  end
  
end
