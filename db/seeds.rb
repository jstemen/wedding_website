# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

invitation_group = InvitationGroup.new(max_guests: 5, code: 'jared')

invitation_group.save!

wedding = Event.new(name: 'wedding', time: DateTime.new)
mandi = Event.new(name: 'mandi', time: DateTime.new)

events = [wedding, mandi]
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

