# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

invitation_group = InvitationGroup.new(max_guests: 5, code: 'jared')

invitation_group.save!

mehndi = Event.new(name: 'Mehndi', time: Date.new(2015,9,24))
mang = Event.new(name: 'Manglik Prasang', time: Date.new(2015,9,25))
wedding = Event.new(name: 'Wedding Ceremony', time: Date.new(2015,9,26))
party = Event.new(name: 'After Party', time: Date.new(2015,9,26))

events = [mehndi,mang, wedding, party]
events.each { |event|
  invitation = Invitation.new
  invitation.event = event
  invitation.invitation_group = invitation_group
  event.save!
  invitation.save!
}

5.times {
  invitation_group.guests << Guest.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
}

invitation_group.save!

