class RouteSearchService

  def self.search(params)
    validate(params);
    routes = Route.joins(route_points: :city)
      .where(route_role: params[:route_role],
             route_points: {
              point_type: [:start_point, :intermediate],
              cities: {name: params[:start_city_name]}
            })
      .joins('INNER JOIN route_points AS a ON a.route_id = routes.id INNER JOIN cities AS cities_a ON cities_a.id = a.city_id')
      .where('a.point_type IN (2) AND cities_a.name=?', params[:finish_city_name])
      .or(Route.joins(route_points: :city)
        .where(route_role: params[:route_role],
               route_points: {
                 point_type: [:start_point],
                 cities: {name: params[:start_city_name]}
               })
        .joins('INNER JOIN route_points AS a ON a.route_id = routes.id INNER JOIN cities AS cities_a ON cities_a.id = a.city_id')
        .where('a.point_type IN (1,2) AND cities_a.name=?', params[:finish_city_name]))
      .distinct
  end

  def self.validate(params)
    unless params.class.ancestors.include? Hash
      raise ArgumentError.new("There must be a Hash of parameters")
    end
    unless params.keys.sort == [:start_city_name, :finish_city_name, :route_role].sort
      raise ArgumentError.new("Hash must include start_city_name, finish_city_name and route_role")
    end
    unless Route.route_roles.keys.include? params[:route_role].to_s
      raise ArgumentError.new("Route role must be specified and be either #{Route.route_roles.keys.join(" or ")}")
    end
    [:start_city_name, :finish_city_name].each do |param|
      unless params[param].to_s.length>0
        raise ArgumentError.new("#{param.to_s.capitalize.split("_").join(" ")} must be specified")
      end
    end
  end

end
