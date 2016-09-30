module ApplicationHelper
  # Long date format
  #
  # @param date [Date] the date object
  # @return day date month year - hour:minutes AM/PM
  def long_date(date)
    date.strftime("%A %d %B %Y - %H:%M %p") rescue 'unknown'
  end

  # Medium date format
  #
  # @param date [Date] the date object
  # @return month/date/year at hour:minutes AM/PM
  def medium_date(date)
    date.strftime("%m/%d/%Y at %H:%M %p") rescue 'unknown'
  end

  # Another style of medium date format
  #
  # @param date [Date] the date object
  # @return day/MONTH/YEAR
  # Produces -> 18 October 2015
  def medium_date2(date)
    date.strftime("%d %B %Y") rescue 'unknown'
  end

  # Short date format
  #
  # @param date [Date] the date object
  # @return year-month-date
  def short_date(date)
    date.strftime("%Y-%m-%d") rescue 'unknown'
  end

  # US date format
  #
  # @param date [Date] the date object
  # @return year-month-date
  def us_date(date)
    date.strftime("%m/%d/%Y at %H:%M %p") rescue 'unknown'
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
