module ApplicationHelper
  def set_date(date)
    date.localtime.strftime("%d.%m.%Y") rescue ''
  end
end
