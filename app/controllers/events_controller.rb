class EventsController < ApplicationController
  before_action :authenticate!

  def create_first_event
    local_datetime = params[:local_datetime]
      @itinerary = current_user.itineraries.new(start_date: local_datetime, travel_days: 1)
      @itinerary.save!
      @pitstop = @itinerary.pitstops.new(stop_number: 1, date_visited: local_datetime)
      @pitstop.save!
      @event = @pitstop.events.new(local_datetime: local_datetime)
      @event.save!
      render "create.json.jbuilder", status: :created
  end

  def create_next_event
    # if expired?
    #   render json: { errors: "ITINERARY IS CLOSED TO NEW PITSTOPS AND EVENTS!" },
    #               status: :unauthorized
    # else
      @itinerary = current_user.itineraries.last
      previous_date = @itinerary.pitstops.last.date_visited
      @new_date = (previous_date.to_date + 1.day).strftime("%Y-%m-%d")
      @pitstop = @itinerary.pitstops.new(stop_number: (@itinerary.pitstops.last.stop_number + 1),
                                         date_visited: @new_date)
      @pitstop.save!
      @itinerary.update(travel_days: (@itinerary.travel_days + 1))
      @event = @pitstop.events.new(local_datetime: @new_date)
      @event.save!
      render "create.json.jbuilder", status: :created
    # end
  end

  def first_event
    local_datetime = params[:local_datetime]
  
      s = Seatgeek.new(local_datetime)
      seatgeek = s.get_first_game
      render json: seatgeek, status: :ok
  end

  def next_event
    previous_date = params[:local_datetime]

      s = Seatgeek.new(previous_date)
      seatgeek = s.get_games
      render json: seatgeek, status: :ok
  end

  def expired?
		expired = false
		@itinerary = current_user.itineraries.find["id"]
		pitstop = @itinerary.pitstops.find["id"]
		last_event = pitstop.events.last
		last_date = last_event.local_datetime
		if DateTime.now > last_date
			expired = true
		end
		expired
	end
end
