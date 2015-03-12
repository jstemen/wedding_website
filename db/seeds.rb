# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
total_failed =0
total_succeeded =0
event_strs = %w{number_invited_guests_-_wedding mehndi_invited number_invited_guests_-_vidhi number_invited_guests_-_after_party}.collect(&:to_s)

event_sym_to_event = {


}
SmarterCSV.process('db/spreadsheet_data.csv', remove_empty_values: false) do |chunk|

  chunk.each { |row|
    begin
      code = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      invitation_group = InvitationGroup.new(code: code)
      guests = []
      #binding.pry
      guests << Guest.create(first_name: row['first-name-primary'.to_sym], last_name: row['last-name-primary'.to_sym])
      guests << Guest.create(first_name: row['first-name-secondary'.to_sym], last_name: row['last-name-secondary'.to_sym])
      if row[:children]
        row[:children].split(',').each { |c| guests << Guest.create(first_name: c) }
      end
      event_strs.each { |event_str|
        count = row[event_str] || 0
        (0..(count-1)).each { |i| invitation_group.invitations << Invitation.create(guest: guests[i]) }
      }
      invitation_group.save!
        total_succeeded += 1
    rescue  Exception => e
      puts "Failed to process: "
      ap row
      ap e
      total_failed += 1
    end
  }
end

puts "total failed imports: #{total_failed}"
puts "total succeeded imports: #{total_succeeded}"
