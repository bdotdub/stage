require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'

require 'fileutils'

require 'stage/helpers'
require 'stage/handlers'

register_handlers
register_helpers

################################################
# Main page stuff
#
get '/' do
  haml :index
end

get '/about' do
  @page = 'about'
  @gpg_key =<<GPG
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.8 (Darwin)

mQGiBEgWcDMRBACgYK4vq4nGOoJwRb5GtKc0rHHtQmpVOfIVtrJaxF0sdO+psD3O
85yHPwhMDzoL5e9NzyPev1eV2w+kPYglNROSkGLfm5OlPuybQNELBQzChAHhwkGU
4q4XHI9SHaLOd9nX6tXMIkJOTHgqUBrPEeF8Qc7Pgop8G140WF9Nj+0DawCgsxo0
2+oqQ8UoqOqLyCoRByubgjcD/3SasGy8lP9unPxkBltYR19ll85gBlKqq8PgyXSg
U2TKuruLQNIItvR9ibiTAJ89svvxDyRVMOnnWIZWWKOLH8fQZS2WQGbYqYrbbEMH
rCmWjsOp8LGhybtc8ybRZRdiZ+BVYzmLZ7KyUjqVP9LyvFzZQr4lBj/NdcGPqIGt
m8bWA/9qA50t0xL/IMEr5buS6Sg5AcWyp2MKE3Qdf+5g89oHc+u41Xa/cfNFHXix
/Y1hEyjggZoDuvQdg6kGDAiRKE0ArMPMJ5MsLJtjzm8jVa37exVk3NRv2aMZdOea
2yEg+4GneWmoaHTJgQgkoljJIR5JOLRJvoGIAkQmQztlYc1nfLQpQmVubnkgV29u
ZyAoU2VlZGxlc3MpIDxiZG90ZHViQGdtYWlsLmNvbT6IYAQTEQIAIAUCSBZwMwIb
AwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEEEP1acSxmj0bXwAnR3Y4b0iHJ17
RWPgN4+MEn4pawxbAKCiEX6FhC9bS78B/MEMnIcM0sv/ULkCDQRIFnAzEAgAtAAs
gl/wfp4yhdxqgYiPlnxi9UkYpmr+2RAn/XYffXJOq/MyljimFBIg3ZV1Dm50AMnz
r1UhAfCWG44dcYMRZNerxAF+EnN0UrnVKaM1EEixxV0VoBlZpKrILMb0dsy2s4/a
IOvMGI5QbzOswBuCdQlMbrVVnNbNGTQ1jxJb98ePQsoftxBmXOHjU/hrfimSgfOV
8R5ZAq1zyF1K+nK3V6ipB2DqBR5eD8RTErEF0CGlIplLcdXvQEzvRXo1cOewxUkb
QsCMtqX9p/Ri26xdvuymOj34UXTux7o0xC+4QGNqxEcgcuwbD+XzzXM2Ex4Lv1NF
YwzRkL+wpYwkLmB90wADBQf/R5kTMkhs1eqbbIQWFYqz2wQXlJltIzR/TwCds9Za
5RltXEOfjuYLTQaPbc98ehxHM6nfJXjgZuzIoG/KkIrtg3uBc+x70lJCpxfTYGeI
0inmy2EDzfjapFLg3HFzEBgYjfZ8yv19bCAaVdFhOB73c7y6dOv6CjSu2su/2v5c
z3C1RpK1kmfmb4y40X6Au4v42HqsuSrP9tMPT2njQhk0G9SFGfrQ5BOJ5AObM1QG
SiRExYfsLf1UOln2EoDNNTNsNKM1Qil88/h8Kr6HSgroGTV8aQ3Hpqq2P3yyIe+M
p61Abl8trnCzA6xMo7h7j/trkLak4dRes9fXPcYZBNWbiIhJBBgRAgAJBQJIFnAz
AhsMAAoJEEEP1acSxmj0ccQAn0PkOgf1KwVvm0ScWN76b3dTWC3hAJ0S5wAIEV/+
D6vHeruuTsL1PkpLCA==
=TEsD
-----END PGP PUBLIC KEY BLOCK-----
GPG

  haml :about
end

get '/stylesheets/bwong.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :bwong
end

################################################
# Upload stuff
#
get '/upload' do
  @files, @directories = Dir.files_and_directories 'public/files/upload'
  haml :upload
end

post '/upload' do
  # Get the uploaded file
  upload_directory = 'public/files/upload'
  upload = params['upload']

  # Parse out the filename
  basefilename = upload[:filename]
  extension = File.extname upload[:filename]
  basefilename.gsub!(extension, '')
  
  # Build the filename
  src = upload[:tempfile].path
  filename = "#{upload_directory}/#{basefilename}#{extension}"

  # Make the directory if it doesn't exist
  FileUtils.mkdir_p(File.dirname src)

  # Iterate through until we find a filename that doesn't already
  # exist
  iter = 1
  while File.exists? filename
    filename = "#{upload_directory}/#{basefilename}_#{iter}#{extension}"
    iter += 1
  end
  
  # Now move it!
  FileUtils.mv(src, filename)
  
  # Compose the notice string
  @notice = File.basename filename
  @notice << " uploaded!"

  @files, @directories = Dir.files_and_directories 'public/files/upload'

  haml :upload
end

get '/upload/*' do
  upload_directory = 'public/files/upload'
  path = params['splat']

  full_path = "#{upload_directory}/#{path}"
  @contents = @filename = nil

  # Check if file exists
  if File.exists? full_path
    # If this is a directory, we must do a listing here
    if File.directory? full_path

    # Else, we just display the file
    else
      @filename = File.basename full_path
      @contents = File.readlines(full_path).map {|l| l.rstrip}
    end
  else
    raise Sinatra::NotFound
  end
  
  haml :upload
end

################################################
# Music stuff
#
get '/music/songs' do
end

get '/music/songs/:song' do
end

get '/music/albums' do
  directory = 'public/files/music/cds'
  @cds = Dir.directories(directory)

  haml :albums
end

get '/music/albums/:album' do
end

use_in_file_templates!
