class Location < ApplicationRecord
  has_many :air_qualities

  validates_presence_of :name

end
