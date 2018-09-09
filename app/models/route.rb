class Route < ApplicationRecord
  has_many :route_points

  validates_length_of :description, :maximum => 100, :allow_blank => true
  enum route_role: {driver:0, passenger:1}
  validates :seats, inclusion: 1..10
  validate :validate_points

  def start_point
    route_points.where(point_type: :start_point).take
  end

  def finish_point
    route_points.where(point_type: :finish_point).take
  end

  def intermediates
    route_points.where(point_type: :intermediate)
  end

  private

  def validate_points
    errors.add(:route_points, "start is missing") if count_points(:start_point) < 1
    errors.add(:route_points, "finish is missing") if count_points(:finish_point) < 1
    errors.add(:route_points, "too many starts") if count_points(:start_point) > 1
    errors.add(:route_points, "too many finishes") if count_points(:finish_point) > 1
  end

  def count_points(point_type)
    route_points.map(&:point_type).delete_if{|f| f != point_type.to_s}.count
  end
end
