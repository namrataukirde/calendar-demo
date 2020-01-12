class TasksController < ApplicationController
  def fetch_and_list_calendar_events
    res = Services::CalendarApi.new(current_user).get_request
    event_list = JSON.parse(res.body)
    event_list["items"].each do |event|
      task                = Task.new
      task.title          = event["summary"]
      task.start          = event["start"]["dateTime"]
      task.end            = event["end"]["dateTime"]
      task.organizer_name = event["organizer"]["displayName"]
      task.save
    end
  end
end
