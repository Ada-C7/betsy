module ApplicationHelper
  def display_time(datetime)
    datetime.in_time_zone('Pacific Time (US & Canada)').strftime('%m/%d/%Y %H:%M %Z')
  end
end
