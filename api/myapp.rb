# myapp.rb
require 'sinatra'
require "sinatra/namespace"

namespace '/api/v1' do
    before do
        content_type 'application/json'
    end
    get '/sports' do
        {'sports': []}.to_json
    end
end

