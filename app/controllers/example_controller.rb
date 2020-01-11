class ExampleController < ApplicationController
  # require 'google/api_client'
  # require 'google/apis'
  def redirect
    debugger
    @calendar = Services::GoogleCalendarWrapper.new(User.first)
    # client = Signet::OAuth2::Client.new(client_options)

    # redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to calendars_url
  end

  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end

  private

  def client_options
    debugger
    {
      client_id: '1096327935695-0dsqjl1k8j6vuahpfralpkjpopnloj1f.apps.googleusercontent.com',
      client_secret: 'MCMZYkU8eJSCqOfXC7M0333d',
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end
end
