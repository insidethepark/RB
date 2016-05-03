class ItineraryController < ApplicationController
	before_action :authenticate!

	def create
		local_datetime = params[:local_datetime]

		@itinerary = current_user.itineraries.create(start_date: params["local_datetime"])
  
        s = Seatgeek.new(local_datetime)
        seatgeek = s.get_first_game
        render json: seatgeek, status: :ok
	end

	def update
		@itinerary = current_user.itineraries.find["id"]
		@itinerary.update(start_date: params["start_date"],
											start_city: params["start_city"],
											travel_days: params["travel_days"])
		render "create.json.jbuilder", status: :ok
	end

	def show
		@itinerary = current_user.itineraries.find_by["id"]
		render "show.json.jbuilder", status: :ok
	end

	def destroy
    @itinerary = current_user.itineraries.find["id"]
    pitstops = Pitstop.where(itinerary_id: @itinerary.id)
    pitstops.each do |pitstop|
      events = Event.where(pitstop_id: pitstop.id)
      events.each do |event|
        event.destroy
      end
      pitstop.destroy
    end
    @itinerary.destroy
    render "show.json.jbuilder", status: :ok
  end

  def reduce
		@itinerary = current_user.itineraries.find["id"]
		if @itinerary.travel_days >= 1
			render json: { errors: "Must have at least 1 pitstop in itinerary.
												To delete the first pitstop, select the option to delete
												the itinerary" },
                  status: :unauthorized
		else
	    @pitstop = @itinerary.pitstops.last
	    events = Event.where(pitstop_id: pitstop.id)
	    events.each do |event|
	      event.destroy
	    end
			@pitstop.destroy
			@itinerary.update(travel_days: (@itinerary.travel_days - 1))
		end
    render "show.json.jbuilder", status: :ok
  end
end
