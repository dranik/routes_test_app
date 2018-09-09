Basic app to showcase service class and some database joins.

### How to run
To start the app make sure you have Ruby 2.3.1 or around installed.

Then install bundler and run it:

```
gem install bundler
bundle install
```
Now you can migrate db:

```
rails db:migrate
rails db:seed
```

And run the app:

```
rails s
```

For the sake of convenience RailsAdmin is installed, so you can do basic CRUD manually on things.

### Service class
The real purpose of this app is to showcase RouteSearchService.

To run it go to the console:
```
rails c
```
In console run:

```ruby
RouteSearchService
  .search(route_role: :passenger,
          start_city_name: "City1",
          finish_city_name: "City2")
```

If there are such routes that satisfy the parameters, it will return ActiveRecord::Relation containing some routes.

If provided data is not uniform with the example above, class will rise ArgumentError and provide error message with it.

To run test, written for this the class, just run:
```
rspec
```
