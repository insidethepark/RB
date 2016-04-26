class CreatePitstops < ActiveRecord::Migration
  def change
    create_table :pitstops do |t|
      t.string :city
      t.integer :itinerary_id
      t.datetime :date_visited

      t.timestamps null: false
    end
  end
end
