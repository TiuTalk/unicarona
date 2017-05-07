module RouteHelper
  def localized_weekdays(route, format: '%A')
    beginning_of_week = Time.zone.now.beginning_of_week(:sunday)

    route.weekdays.map do |day|
      date = beginning_of_week + weekdays.index(day.to_s).days
      I18n.l(date, format: format)
    end
  end

  private

  def weekdays
    @weekdays ||= Date::DAYNAMES.map(&:downcase)
  end
end
