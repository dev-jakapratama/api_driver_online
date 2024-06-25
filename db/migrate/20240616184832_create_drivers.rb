class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers do |t|
      t.string :username 
      t.string :password 
      t.string :email 
      t.string :phone 
      t.string :vehicle_details 

      t.timestamps
    end
  end
end
