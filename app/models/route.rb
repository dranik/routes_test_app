class Route < ApplicationRecord
  has_many :route_points

  validates_length_of :description, :maximum => 100, :allow_blank => true
  enum route_role: {driver:0, passenger:1}
  validates :seats, inclusion: 1..10
end
