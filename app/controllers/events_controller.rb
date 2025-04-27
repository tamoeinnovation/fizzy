class EventsController < ApplicationController
  include DayTimelinesScoped

  def index
    @filters = Current.user.filters.all
  end
end
