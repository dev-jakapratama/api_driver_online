class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.integer :driver_id
      t.string  :pickup_location
      t.string  :dropoff_location
      t.string  :status 

      t.timestamps
    end
  end
end
