class TasksController < ApplicationController
  def fetch_and_list_calendar_events
    res = Services::CalendarApi.new(current_user).get_request
    event_list = JSON.parse(res.body)
    Services::TaskBuilder.new(event_list["items"], current_user).create_or_update
  end
end
