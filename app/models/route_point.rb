class RoutePoint < ApplicationRecord
  belongs_to :route, optional: true
  belongs_to :city
  enum point_type: {start_point:0, intermediate:1, finish_point:2}
end
