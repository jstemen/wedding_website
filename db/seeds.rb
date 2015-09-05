Admin.create(email: 'admin@example.com', password: 'admin@example.com').save!

time_zone = DateTime.now.in_time_zone
events = [
    Event.create!(name: 'Wedding', time: time_zone),
    Event.create!(name: 'Mehndi', time: time_zone),
    Event.create!(name: 'Vidhi', time: time_zone),
    Event.create!(name: 'After Party', time: time_zone)
]


pool_array =[('A'..'Z'), (0..9)].inject { |a, b| a.to_a + b.to_a }

100.times {
  rsvp_code = (0..7).map { pool_array[rand(pool_array.size)] }.join
  invitation_group = InvitationGroup.new(code: rsvp_code)
  (0..rand(5)).each {
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    guest = Guest.new(first_name: first_name, last_name: last_name, email_address: "#{first_name}#{last_name}@mailinator.com")
    puts "Created guest: #{guest.full_name}"
    events.each { |event|
      if rand > 0.7
        invitation_group.invitations << Invitation.new(guest: guest, event: event, invitation_group: invitation_group)
      end
    }
    invitation_group.save!
  }
}
