require_relative '../utils/helpers'

module GetSportEventsAndOutcomes
    def GetSportEventsAndOutcomes.get_outcomes_by_sport_end_event_id(settings, params)
        json_data = Helpers.get_data(settings, "all_sports")
        pp 'sport id:', params['sport_id']
        pp 'event_id:', params['event_id']
        JSON.dump(json_data[params['sport_id'].to_i]['events'][params['event_id'].to_i]['outcomes'])
    end
end