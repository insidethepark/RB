json.itenerary @itinerary do |itinerary|
	json.(itenerary, :zip, :start_date)

		json.pitstops itinerary.pitstops do |pitstops|
			json.(pitstops, :id, :itinerary_id, :date_visited, :zip)
		
		end	
end			