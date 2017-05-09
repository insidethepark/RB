class ItineraryController < ApplicationController

	def create
	 	@itinerary = current_user.itineraries.create(start_date: params["local_datetime"])
    	s = Seatgeek.new
    	@seatgeek = s.get_first_game(@itinerary.start_date.strftime("%Y-%m-%d"))
    	# render json: seatgeek, status: :ok
		render :json => { :itinerary => @itinerary.id,
      			          :seatgeek => @seatgeek }
	end

	def update
		@itinerary = current_user.itineraries.find params["id"]
		@itinerary.update(start_date: params["start_date"],
											start_city: params["start_city"],
											travel_days: params["travel_days"])
		render "create.json.jbuilder", status: :ok
	end

	def show
		@itinerary = current_user.itineraries.find_by(id: params["itinerary_id"])
		@pitstops = @itinerary.pitstops.last
		@pitstop_dates = @itinerary.pitstops.pluck(:date_visited).join(",").split(/,/),
						((@itinerary.pitstops.pluck(:date_visited).last.to_date) + 1.day).strftime
		@game_data = @itinerary.pitstops.includes(:events).pluck(:game_number).join(",")
		s = Seatgeek.new
		@seatgeek = s.all_games(@game_data)
		render :json => { :pitstop_dates => @pitstop_dates,
			              :seatgeek => @seatgeek }
	end

	def index
		@itineraries = current_user.itineraries
		render "index.json.jbuilder", status: :ok
	end

	# def destroy
 #      @itinerary = current_user.itineraries.find params["id"]
 #      # dependent: :destroy
 #    pitstops = Pitstop.where(itinerary_id: @itinerary.id)
 #    pitstops.each do |pitstop|
 #      events = Event.where(pitstop_id: pitstop.id)
 #      events.each do |event|
 #        event.destroy
 #      end
 #      pitstop.destroy
 #    end
 #    # @itinerary.destroy
 #    # render {}, status: :no_content
  # end

  # def reduce
		# @itinerary = current_user.itineraries.find["id"]
		# if @itinerary.travel_days >= 1
		# 	render json: { errors: "Must have at least 1 pitstop in itinerary.
		# 										To delete the first pitstop, select the option to delete
		# 										the itinerary" },
  #                 status: :unauthorized
		# else
	 #    @pitstop = @itinerary.pitstops.last
	 #    events = Event.where(pitstop_id: pitstop.id)
	 #    events.each do |event|
	 #      event.destroy
	 #    end
		# 	@pitstop.destroy
		# 	@itinerary.update(travel_days: (@itinerary.travel_days - 1))
		# end
  #   render "show.json.jbuilder", status: :ok
  # end
end
