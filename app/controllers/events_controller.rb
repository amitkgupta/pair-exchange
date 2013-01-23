class EventsController < ApplicationController

  def create
    Event.create!(
      location: params[:event][:location],
          date: DateTime.strptime(params[:event][:date],'%m/%d/%Y').to_date
    )

    redirect_to admin_path
  end
end