require_relative '../utils/helpers'

module GetSportById
    def GetSportById.get_sport_by_id(settings, params)
        json_data = Helpers.get_data(settings, "all_sports")
        pp params['sport_id']
        JSON.dump({'sport': json_data[params['sport_id'].to_i], 'events': json_data[params['sport_id'].to_i]['events']})
    end
end