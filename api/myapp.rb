# myapp.rb
require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'net/https'
require 'uri'
require 'pp'
require 'json'

def get_inplay_json(url)
    pp "url: ", url
    uri = URI.parse(url)


    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # This request uses proxy.
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    
    pp "response:", response
    case response
    when Net::HTTPSuccess then
        JSON.parse(response.body)
    else
        "No content"
    end
end

def get_json_file_content(data_file_path)
    data = File.read(data_file_path)
    JSON.parse(data)
end

def get_data(settings)
    if settings.use_data_file
        json_array = get_json_file_content(settings.data_file_path)
    elsif settings.use_proxy
        json_array = get_inplay_json(settings.url_with_proxy)
    else
        json_array = get_inplay_json(settings.url)
    end
    new_hash = {}
    json_array['sports'].each do |sport|
        new_hash[sport['id']] = sport
    end
    new_hash
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
            JSON.dump(json_data[params['sport_id'].to_i])
        end
    end
    run!
end

