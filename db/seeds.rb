# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Migration.say_with_time 'Creating users...' do
  FactoryGirl.create(:user, name: 'Usuário Teste', email: 'user@example.com', password: 'password')
  FactoryGirl.create_list(:user, 10)
  User.count
end if User.count.zero?

ActiveRecord::Migration.say_with_time 'Creating routes...' do
  streets = ['Unicarioca', 'Estácio', 'Tijuca', 'Sambódromo', 'Praia de Ipanema', 'Rua Raul Pompéia - Copacabana', 'Av. Paulo de Frontin - Rio Comprido', 'Av. Maracanã - Tijuca', 'Rua Nascimento Silva - Ipanema', 'Rua Farme de Amoedo - Ipanema', 'Av. Presidente Vargas - Centro', 'Av. Rio Branco - Centro', 'Rua da Glória - Glória']
  hours = ['18:00', '07:00', '12:00']
  weekdays = %w(monday tuesday friday sunday)
  users = User.all

  rand(5..15).times do
    origin = streets.sample
    destination = streets.reject { |s| s == origin }.sample

    origin = origin.gsub(' - ', ", #{rand(100..500)} - ")
    destination = destination.gsub(' - ', ", #{rand(100..500)} - ")

    defaults = { origin_latitude: nil, origin_longitude: nil, destination_latitude: nil, destination_longitude: nil }
    FactoryGirl.create(:route, { user: users.sample, origin: origin, destination: destination, hour: hours.sample, weekdays: weekdays }.merge(defaults))
  end

  Route.count
end if Route.count.zero?
