module Helpers
    def Helpers.create_hash_from_json(json_array)
        new_hash = {}
        json_array['sports'].each do |sport|
            new_hash[sport['id']] = sport
            new_hash[sport['id']]['events'] = {}
            if sport.key?("comp")
                sport['comp'].each do |comp|
                    if comp.key?("events")
                        comp['events'].each do |event|
                            new_hash[sport['id']]['events'][event['id']] = event
                            new_hash[sport['id']]['events'][event['id']]['outcomes'] = {}
                            if event.key?("markets")
                                event['markets'].each do |market|
                                    new_hash[sport['id']]['events'][event['id']]['outcomes'] = market['o']
                                end
                            end
                        end
                    end
                end
            end
        end
        new_hash
    end
end