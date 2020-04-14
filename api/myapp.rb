# myapp.rb
require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require_relative './utils/get_json'
require_relative './utils/helpers'
require 'pp'
require 'json'

def get_data(settings)
    json_array = GetJson.get_inplay_json(settings.url, settings.use_proxy, settings.proxy_address, settings.proxy_port)
    
    Helpers.create_hash_from_json(json_array)
end

class MyApp < Sinatra::Base
    register Sinatra::ConfigFile
    register Sinatra::Namespace
    register Sinatra::CrossOrigin

    configure do
        enable :cross_origin
    end
  
    config_file 'config.yml'
  
    namespace '/api/v1' do
        before do
            content_type 'application/json'
        end
        get '/sports' do
            json_data = get_data(settings)
            array_of_sports = []
            json_data.each do |sport_id, sport|
                array_of_sports << {'desc' => sport['desc'], 'id' => sport_id}
            end
            JSON.dump(array_of_sports)
        end

        get '/sports/:sport_id' do
            json_data = get_data(settings)
            pp params['sport_id']
            pp json_data
            JSON.dump({'sport': json_data[params['sport_id'].to_i], 'events': json_data[params['sport_id'].to_i]['events']})
        end

        get '/sports/:sport_id/events/:event_id' do
            json_data = get_data(settings)

        end
    end
    run!
end

