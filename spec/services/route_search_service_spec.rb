require "rails_helper"

describe RouteSearchService do
  describe "search" do

    context "with incorrect params" do
      it "raises an exception if hash is not passed" do
        expect {
          RouteSearchService.search(5)
        }.to raise_error(ArgumentError, "There must be a Hash of parameters")
      end
      it "raises an exception if hash is passed with incorrect set of fields" do
        expect {
          RouteSearchService.search(a: FFaker::Lorem.word, start_city_name: FFaker::Address.city)
        }.to raise_error(ArgumentError, "Hash must include start_city_name, finish_city_name and route_role")
      end
      it "raises an exception if route_role is not #{Route.route_roles.keys.join(" or ")}" do
        expect {
          RouteSearchService.search(route_role: FFaker::Lorem.word,
                                    start_city_name: FFaker::Address.city,
                                    finish_city_name: FFaker::Address.city)
        }.to raise_error(ArgumentError, "Route role must be specified and be either #{Route.route_roles.keys.join(" or ")}")
      end
      it "raises an exception if start_city_name is not set" do
        expect {
          RouteSearchService.search(route_role: Route.route_roles.keys.sample,
                                    start_city_name: "",
                                    finish_city_name: FFaker::Address.city)
        }.to raise_error(ArgumentError, "Start city name must be specified")
      end
      it "raises an exception if start_city_name is not set" do
        expect {
          RouteSearchService.search(route_role: Route.route_roles.keys.sample,
                                    start_city_name: FFaker::Address.city,
                                    finish_city_name: "")
        }.to raise_error(ArgumentError, "Finish city name must be specified")
      end
    end

    context "with correct params" do
      it "returns a relation" do
        data = RouteSearchService.search(route_role: Route.route_roles.keys.sample,
                                          start_city_name: FFaker::Address.city,
                                          finish_city_name: FFaker::Address.city)
        expect(data).to be_a_kind_of ActiveRecord::Relation
      end
    end

    context "a single matching route" do
      let(:route) { FactoryBot.create(:route) }
      let!(:random_routes) { FactoryBot.create_list(:route, 20) }
      it "finds a record by the start and the finish" do
        data = RouteSearchService.search(route_role: route.route_role,
                                         start_city_name: route.start_point.city.name,
                                         finish_city_name: route.finish_point.city.name)
        expect(data.count).to eq 1
        expect(data.first.id).to eq route.id
      end
      it "finds a record by the intermediate and the finish" do
        data = RouteSearchService.search(route_role: route.route_role,
                                         start_city_name: route.intermediates.take.city.name,
                                         finish_city_name: route.finish_point.city.name)
        expect(data.count).to eq 1
        expect(data.first.id).to eq route.id
      end
      it "finds a record by the start and the intermediate" do
        data = RouteSearchService.search(route_role: route.route_role,
                                         start_city_name: route.start_point.city.name,
                                         finish_city_name: route.intermediates.take.city.name)
        expect(data.count).to eq 1
        expect(data.first.id).to eq route.id
      end
      it "fails to find finds a record by the finish and the intermediate because of the wrong order" do
        data = RouteSearchService.search(route_role: route.route_role,
                                         start_city_name: route.finish_point.city.name,
                                         finish_city_name: route.intermediates.take.city.name)
        expect(data.count).to eq 0
      end
      it "fails to find finds a record by the start and the intermediate because of the wrong order" do
        data = RouteSearchService.search(route_role: route.route_role,
                                         start_city_name: route.intermediates.take.city.name,
                                         finish_city_name: route.start_point.city.name)
        expect(data.count).to eq 0
      end
    end

    context "multiple matching routes" do
      let!(:city_a)  { FactoryBot.create(:city) }
      let!(:city_b)  { FactoryBot.create(:city) }
      let!(:route_1) { FactoryBot.create( :route,
                                          route_role: :driver,
                                          route_points: [FactoryBot.create(:route_point,
                                                                           :start_point,
                                                                           city: city_a),
                                                         FactoryBot.create(:route_point,
                                                                           :finish_point,
                                                                           city: city_b)]) }
       let!(:route_2) { FactoryBot.create( :route,
                                          route_role: :driver,
                                          route_points: [FactoryBot.create(:route_point,
                                                                           :start_point,
                                                                           city: city_a),
                                                         FactoryBot.create(:route_point,
                                                                           :finish_point,
                                                                           city: city_b)]
                                                         .concat(FactoryBot.create_list(:route_point, 9, point_type: :intermediate))) }
       let!(:route_3) { FactoryBot.create( :route,
                                          route_role: :driver,
                                          route_points: [FactoryBot.create(:route_point,
                                                                           :start_point),
                                                         FactoryBot.create(:route_point,
                                                                           :finish_point)]
                                                         .concat(FactoryBot.create_list(:route_point, 9, point_type: :intermediate))) }
       let!(:route_4) { FactoryBot.create( :route,
                                         route_role: :driver,
                                         route_points: [FactoryBot.create(:route_point,
                                                                          :start_point,
                                                                          city: city_a),
                                                        FactoryBot.create(:route_point,
                                                                          :intermediate,
                                                                          city: city_b),
                                                        FactoryBot.create(:route_point,
                                                                          :finish_point)]
                                                        .concat(FactoryBot.create_list(:route_point, 9, point_type: :intermediate))) }
       let!(:route_5) { FactoryBot.create( :route,
                                           route_role: :driver,
                                           route_points: [FactoryBot.create(:route_point,
                                                                            :intermediate,
                                                                            city: city_a),
                                                          FactoryBot.create(:route_point,
                                                                            :finish_point,
                                                                            city: city_b),
                                                          FactoryBot.create(:route_point,
                                                                            :start_point)]
                                                          .concat(FactoryBot.create_list(:route_point, 9, point_type: :intermediate))) }
       let!(:route_6) { FactoryBot.create( :route,
                                          route_role: :driver,
                                          route_points: [FactoryBot.create(:route_point,
                                                                           :start_point),
                                                         FactoryBot.create(:route_point,
                                                                           :intermediate,
                                                                           city: city_b),
                                                         FactoryBot.create(:route_point,
                                                                           :finish_point)]
                                                         .concat(FactoryBot.create_list(:route_point, 9, point_type: :intermediate))) }
       it "finds the right number of records" do
         data = RouteSearchService.search(route_role: :driver,
                                         start_city_name: city_a.name,
                                         finish_city_name: city_b.name)
         expect(data.count).to eq 4
      end
    end
  end
end
