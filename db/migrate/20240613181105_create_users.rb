class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
      t.string :phone
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
