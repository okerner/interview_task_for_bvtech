require_relative '../utils/get_json'

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
    def Helpers.get_data(settings, redis_key = "")
        if settings.use_redis_for_cache
            redis = Redis.new(host: settings.redis_url_or_ip, port: settings.redis_port, db: 15)
        end
    
        if redis
            pp "json data from cache"
            json_array = redis.get(redis_key)
            if !json_array
                pp "json data from url"
                json_array = GetJson.get_inplay_json(settings.url, settings.use_proxy, settings.proxy_address, settings.proxy_port)
                redis.set(redis_key, JSON.dump(json_array))
                redis.expire(redis_key, 3600)
            end
        else
            json_array = GetJson.get_inplay_json(settings.url, settings.use_proxy, settings.proxy_address, settings.proxy_port)        
        end
    
        if json_array.is_a? String
            json_array = JSON.parse(json_array)
        end
        
        self.create_hash_from_json(json_array)
    end
end