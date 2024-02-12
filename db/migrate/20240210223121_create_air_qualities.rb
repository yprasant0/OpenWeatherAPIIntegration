class CreateAirQualities < ActiveRecord::Migration[7.0]
  def change
    create_table :air_qualities do |t|
      t.references :location, null: false, foreign_key: true
      t.integer :aqi
      t.float :pm2_5
      t.float :pm10
      t.float :co
      t.float :so2
      t.float :no2
      t.float :o3
      t.datetime :measured_at
      t.float :nh3
      t.float :no

      t.timestamps
    end
  end
end
