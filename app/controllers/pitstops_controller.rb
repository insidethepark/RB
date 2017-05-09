class PitstopsController < ApplicationController

  def create
    @itinerary = current_user.itineraries.find params["id"]
    @pitstop = @itinerary.pitstops.create(date_visited: params["local_datetime"], city: params["city"])
    render "create.json.jbuilder"
  end

  def show
    @itinerary = Itinerary.find params[:id]
    @pitstop = itinerary.pitstops.find params[:pitstop_id]
    @event = @pitstop.events.all
    render "show.json.jbuilder", status: :ok
  end

  # def update
  #   itinerary = Itinerary.find params["id"]
  #   @itinerary = itinerary.pitstops params["id"]
  #   @itinerary.update(city: params['city'])
  #   render "create.json.jbuilder", status: :ok
  # end

  def destroy
    ## look up the itinerary
    ## looking up the pitstop
    ## calling destroy on it
    itinerary = Itinerary.find["id"]
    @pitstop = itinerary.pitstops.find["id"]
    @pitstop.events.each do |event|
      event.destroy
    end
    @pitstop.destroy
    render plain: "PITSTOP DESTROYED",
    status: :accepted
  end
end
