# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin

wedding = Event.create(name: 'wedding', time: DateTime.new)
mandi = Event.create(name: 'mandi', time: DateTime.new)
invitation = Invitation.create(code:'monkey', max_guests: 3)
invitation.events << wedding
invitation.events << mandi
invitation.save!
=end

