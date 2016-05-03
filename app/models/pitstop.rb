class Pitstop < ActiveRecord::Base
  has_many :events
  belongs_to :itinerary
end
