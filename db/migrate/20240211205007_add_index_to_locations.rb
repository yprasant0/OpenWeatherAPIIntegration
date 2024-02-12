class AddIndexToLocations < ActiveRecord::Migration[7.0]
  def change
    add_index :locations, :name
  end
end
