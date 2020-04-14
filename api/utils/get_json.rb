require 'net/https'
require 'uri'
require 'pp'

module GetJson
    def GetJson.get_inplay_json(url, use_proxy, proxy_address, proxy_port, limit = 10)
        pp "url: ", url
        uri = URI.parse(url)

        raise ArgumentError, 'HTTP redirect too deep' if limit == 0   

        if use_proxy
            http = Net::HTTP.new(uri.host, uri.port, proxy_address, proxy_port)
            if uri.scheme == "https"
                http.use_ssl = true
            end
        else
            http = Net::HTTP.new(uri.host, uri.port)
            if uri.scheme == "https"
                http.use_ssl = true
            end
        end

        pp http

        request = Net::HTTP::Get.new(uri.request_uri)
        pp request
        response = http.request(request)
        
        pp "response:", response
        case response
        when Net::HTTPSuccess     then JSON.parse(response.body)
        when Net::HTTPRedirection then 
            pp "Redricted needed, response[location]: ", response['location']
            get_inplay_json(response['location'], use_proxy, proxy_address, proxy_port, limit - 1)
        else
            "No content"
        end
    end
end
