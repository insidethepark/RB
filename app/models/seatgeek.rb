class Seatgeek
  include HTTParty
  base_uri "https://api.seatgeek.com/2"
  format :json

  def initialize(start_date)
    @headers = {
          "Authorization" =>  ENV["MYCLIENTID"],
          "User-Agent"    =>  "HTTParty"
      }
        @defaults = {
          "per_page" => 15,
          "taxonomies.id" => 1010100
        }
    @start_date = start_date
    @end_date = (start_date.to_date + 1.day).strftime("%Y-%m-%d")
    @start_date2 = @end_date
    @end_date2 = (start_date.to_date + 2.day).strftime("%Y-%m-%d")
  end

  def get_first_game
    options = {
      "datetime_local.gte" => @start_date,
      "datetime_local.lte" => @end_date
    }
    params = @defaults.merge(options)
    query = Seatgeek.get("/events", query: params, headers: @headers)
  end

  def get_games
    options = {
      "datetime_local.gte" => @start_date2,
      "datetime_local.lte" => @end_date2
    }
    params = @defaults.merge(options)

    query = Seatgeek.get("/events", query: params, headers: @headers)
  end
end
