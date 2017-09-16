require 'sinatra'
require 'base64'

set :port, 4243
set :json_encoder, :to_json

HOMEPATH = 'spec/fixtures/'

before do
  authenticate
end

def store_file(file_string, camera_id)
  f = File.open(destination(camera_id), 'w+')
  f.write(Base64.decode64(file_string))
  f.close
end

def destination(camera_id)
  dir = File.join HOMEPATH, camera_id
  FileUtils.mkdir(dir) unless File.directory? dir
  File.join  dir, "#{Time.new.strftime('%Y%m%d_%H%M')}.jpg"
end

helpers do
  def authenticate
    halt unless request['X-Auth-Token'] != 'TOKEN'
  end
end

post '/snapshots' do
  params = JSON.parse(File.read(request.body))
  snapshot = params['snapshot']
  store_file(snapshot['file'], snapshot['camera_id'])
  status 201
end
