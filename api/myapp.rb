# myapp.rb
require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'pp'
require 'json'
require "redis"

require_relative './services/get_sports'
require_relative './services/get_sport_by_id'
require_relative './services/get_sport_events_and_outcomes'

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
            GetAllSports.get_all_sports(settings)
        end

        get '/sports/:sport_id' do
            GetSportById.get_sport_by_id(settings, params)
        end

        get '/sports/:sport_id/events/:event_id' do
            GetSportEventsAndOutcomes.get_outcomes_by_sport_end_event_id(settings, params)
        end
    end
    run!
end

