FactoryBot.define do
  factory :route do
    route_points  { [FactoryBot.create(:route_point, :start_point),
                     FactoryBot.create(:route_point, :finish_point),
                     FactoryBot.create(:route_point, :intermediate)] }
    route_role    { Route.route_roles.keys.sample }
    seats         { [*1..4].sample }
    description    { FFaker::Lorem.sentence }
  end
end
