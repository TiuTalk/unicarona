class CreateRides < ActiveRecord::Migration[5.1]
  def change
    create_table :rides do |t|
      t.references :driver, foreign_key: { to_table: :users }
      t.references :passenger, foreign_key: { to_table: :users }
      t.references :route, foreign_key: true
      t.boolean :driver_liked, default: false
      t.boolean :passenger_liked, default: false
      t.string :status

      t.timestamps
    end
  end
end
