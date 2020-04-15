require "./test_helper"
require "json"

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.mock_with :rspec
end

describe MyApp do
    let(:app) { MyApp.new }
    list_of_sports = []
    list_of_events = []

    context "GET to /api/v1/sports" do
        let(:response) { get "api/v1/sports" }

        it "returns status 200 OK" do
            list_of_sports = JSON.parse(response.body)
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            expect(list_of_sports.length()).to be > 0
        end
    end

    context "GET to /api/v1/sports/:sport_id" do
        let(:response) { get "api/v1/sports/#{list_of_sports.first['id'].to_s}" }

        it "returns status 200 OK" do
            json_data = JSON.parse(response.body)
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
            expect(json_data['sport']['id']).to eq(list_of_sports.first['id'])
        end
        it "returns sport is equal with the first element of list_of_sports" do
            json_data = JSON.parse(response.body)
            expect(json_data['sport']['id']).to eq(list_of_sports.first['id'])
        end
        it "returns sport with events section" do
            json_data = JSON.parse(response.body)
            list_of_events = json_data['events']
            expect(json_data['events'].length()).to be > 0
        end
    end

    context "GET to /api/v1/sports/:sport_id/events/:event_id" do
        let(:response) { get "api/v1/sports/#{list_of_sports.first['id'].to_s}/events/#{list_of_events.values.first['id'].to_s}" }

        it "returns status 200 OK" do
            expect(response.status).to eq 200
            expect(response.content_type).to eq("application/json")
        end
        it "returns outcomes length is not zero" do
            json_data = JSON.parse(response.body)
            expect(json_data.length()).to be > 0
        end
    end
end