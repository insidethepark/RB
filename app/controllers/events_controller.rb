class EventsController < ApplicationController
  before_action :authenticate!

  def create
    @itinerary = current_user.itineraries.find(params[:itinerary_id])
 	date_visited = params["local_datetime"]
 	if @itinerary.pitstops
 		date_visited = (@itinerary.pitstops.last.date_visited.to_date + 1.day).strftime("%Y-%m-%d")
 	end	
    @pitstop = @itinerary.pitstops.find_or_create_by(date_visited: date_visited)
    @event = @pitstop.events.create(game_number: params["game_number"])
    # @event.update_from_seatgeek
    
	render :json => { :itinerary => @itinerary.id, 
      			      :pitstop => @pitstop.date_visited,
      			      :event => @event }
  end

  def next_event
  	@itinerary = current_user.itineraries.find(params[:itinerary_id])
  	@pitstop = @itinerary.pitstops.last
  	
  	s = Seatgeek.new(@pitstop.date_visited)
    @seatgeek = s.get_games

    render json: @seatgeek, status: :ok
  end

  # private
  # def event_params
  # 	params.permit(:game_number)
  # end

end
