require_relative '../utils/helpers'

module GetAllSports
    def GetAllSports.get_all_sports(settings)
        json_data = Helpers.get_data(settings, "all_sports")
        array_of_sports = []
        json_data.each do |sport_id, sport|
            array_of_sports << {'desc' => sport['desc'], 'id' => sport_id}
        end
        JSON.dump(array_of_sports)
    end
end