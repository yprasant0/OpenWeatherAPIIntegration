class AddIndexToAirQualities < ActiveRecord::Migration[7.0]
  #use strong_migrations gem for better safety
  def change
    add_index :air_qualities, [:measured_at, :location_id]
  end
end
