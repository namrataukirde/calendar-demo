module Services
  class CalendarApi
    URL = "https://www.googleapis.com/oauth2/v4/token"
    CALENDAR_URL = "https://www.googleapis.com/calendar/v3/calendars/primary/events"
    # "https://www.googleapis.com/calendar/v3/users/me/calendarList"
    # "https://www.googleapis.com/calendar/v3/calendars/primary/events"

    attr_accessor :current_user

    def initialize(current_user)
      self.current_user = current_user
    end

    def post_request
      req = post_req

      req.set_form_data('client_id': '1096327935695-0dsqjl1k8j6vuahpfralpkjpopnloj1f.apps.googleusercontent.com',
          'client_secret': 'MCMZYkU8eJSCqOfXC7M0333d',
          'refresh_token': User.first.refresh_token,
          'grant_type': 'refresh_token')

      res = Net::HTTP.start(new_uri.hostname, new_uri.port) do |http|
        http_obj.request(req)
      end
      puts res.body
    end

    def get_request
      http_obj.request(request_with_headers)
    end

    def post_req
      Net::HTTP::Post.new(new_uri)
    end

    def get_req
      Net::HTTP::Get.new(new_calendar_uri.path)
    end

    def request_with_headers
      request = get_req
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{current_user.token}"
      request
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

    def new_calendar_uri
      @calendar_uri ||= URI.parse(CALENDAR_URL)
    end
  end
end
