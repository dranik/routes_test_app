FactoryBot.define do
  factory :route_point do
    trait :finish_point do
      point_type :finish_point
    end
    trait :start_point do
      point_type :start_point
    end
    trait :intermediate do
      point_type :intermediate
    end
    city
    point_type  { RoutePoint.point_types.keys.sample }
    point_at    { FFaker::Time.datetime }
  end
end
