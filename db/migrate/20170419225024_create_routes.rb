class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.references :user
      t.string :origin
      t.string :destination
      t.string :weekdays
      t.time :hour
      t.boolean :enabled, default: true
      t.decimal :origin_latitude, precision: 9, scale: 6
      t.decimal :origin_longitude, precision: 9, scale: 6
      t.decimal :destination_latitude, precision: 9, scale: 6
      t.decimal :destination_longitude, precision: 9, scale: 6

      t.timestamps
    end
  end
end
