class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.string :state
      t.string :country

      t.timestamps
    end
    add_index :locations, :state
  end
end
