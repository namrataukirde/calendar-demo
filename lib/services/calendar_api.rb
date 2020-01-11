module Services
  class CalendarApi
    URL = "https://www.googleapis.com/oauth2/v4/token"

    #replace User.first wuth current_user
    def post_request
      # uri =  URI("https://www.googleapis.com/oauth2/v4/token")
      # parsed_url = URI.parse(url)
      # http = Net::HTTP.new(new_uri.host, new_uri.port)
      # http.use_ssl = true
      req = Net::HTTP::Post.new(new_uri)

      req.set_form_data('client_id': '1096327935695-0dsqjl1k8j6vuahpfralpkjpopnloj1f.apps.googleusercontent.com',
          'client_secret': 'MCMZYkU8eJSCqOfXC7M0333d',
          'refresh_token': User.first.refresh_token,
          'grant_type': 'refresh_token')

      res = Net::HTTP.start(new_uri.hostname, new_uri.port) do |http|
        http_obj.request(req)
      end
      puts res.body
    end

    def http_obj
      @http ||=  Net::HTTP.new(new_uri.host, new_uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      @http.read_timeout = 500
      @http
    end

    def new_uri
      @uri ||= URI.parse(URL)
    end
  end
end
