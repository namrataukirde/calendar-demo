module Services
  class TaskBuilder
    GOOGLE_CALENDAR_API_STRING_FIELD_TO_TASK_MAPPING = {
      "summary" => "title"
    }

    GOOGLE_CALENDAR_API_DATE_TIME_FIELD_TO_TASK_MAPPING = {
      "start" => "start",
      "end"  => "end"
    }

    attr_accessor :event_list, :task, :event

    def initialize(event_list_response)
      @event_list = event_list_response
      @task = nil
      @event = nil
    end

    def create_or_update
      event_list.each do |event|
        @event = event
        @task = Task.where(google_event_id: event["iCalUID"]).first_or_create
        assign_field_values
        assign_date_field_values
        task.save
      end
    end

    def assign_field_values
      GOOGLE_CALENDAR_API_STRING_FIELD_TO_TASK_MAPPING.each do |gcal_field, task_db_column|
        task.send("#{task_db_column}=", event[gcal_field]) unless event[gcal_field].blank?
      end
    end

    def assign_date_field_values
      GOOGLE_CALENDAR_API_DATE_TIME_FIELD_TO_TASK_MAPPING.each do |gcal_date_field, task_db_column|
        if event[gcal_date_field].present?
          value = event[gcal_date_field]["dateTime"] || event[gcal_date_field]["date"]
          task.send("#{task_db_column}=", value)
        end
      end
    end
  end
end
