require 'faker'

User.delete_all
Event.delete_all

100.times do
  User.create :first_name => Faker::Name.first_name,
  :last_name  => Faker::Name.last_name,
  :email      => Faker::Internet.email,
  :password => Faker::Name.last_name,
  :birthdate  => Date.today - 15.years - rand(20000).days
end

50.times do
  start_time = Time.now + (rand(61) - 30).days
  end_time   = start_time + (1 + rand(6)).hours

  Event.create :creator_id    => (1..50).to_a.sample,
  :name       => Faker::Company.name,
  :location   => "#{Faker::Address.city}, #{Faker::Address.state_abbr}",
  :starts_at => start_time,
  :ends_at   => end_time
end

20.times do
  attendee_id = (1..100).to_a
  event_id = (1..20).to_a
  EventAttendance.create(attendee_id: attendee_id.sample, event_id: event_id.sample)
end

