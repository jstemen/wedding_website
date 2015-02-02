# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

invitation_group = InvitationGroup.create(max_guests: 5, code: 'monkey')


wedding = Event.create(name: 'wedding', time: DateTime.new)
mandi = Event.create(name: 'mandi', time: DateTime.new)

events = [wedding, mandi]
events.each { |event|
  invitation = Invitation.build
  invitation.event = event
  invitation_group.invitations << invitation
}
invitation_group.save!

