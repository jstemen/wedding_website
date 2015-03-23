# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def create_guest(first_name, last_name)
  Guest.create!(first_name: first_name, last_name: last_name) 
end 
total_failed =0
total_succeeded =0
time_zone = DateTime.now.in_time_zone
event_str_to_event = {
    'number_invited_guests_-_wedding' => Event.create!(name: 'Wedding', time: time_zone),
    'mehndi_invited' => Event.create!(name: 'Mehndi', time: time_zone),
    'number_invited_guests_-_vidhi' => Event.create!(name: 'Vidhi', time: time_zone),
    'number_invited_guests_-_after_party' => Event.create!(name: 'After Party', time: time_zone)
}
event_sym_to_event = {}
event_str_to_event.each{|key,value|
  event_sym_to_event[key.to_sym] = value
}

SmarterCSV.process('db/spreadsheet_data.csv', remove_empty_values: false) do |chunk|

  chunk.each { |row|
    begin
      code = (0..7).map { (('a'..'z').to_a + (0..9).to_a)[rand(36)] }.join
      invitation_group = InvitationGroup.create(code: code)
      guests = []
      unless row['first-name-primary'.to_sym].blank?
        guests << Guest.create!(first_name: row['first-name-primary'.to_sym], last_name: row['last-name-primary'.to_sym])
      end
      unless row['first-name-secondary'.to_sym].blank?
        guests << Guest.create!(first_name: row['first-name-secondary'.to_sym], last_name: row['last-name-secondary'.to_sym])
      end
 
      unless row[:children].blank?
        row[:children].split(',').each { |c| guests << Guest.create!(first_name: c) }
      end
      event_sym_to_event.each { |event_sym, event|

        count = row[event_sym]
        (0..(count-1)).each { |i| invitation_group.invitations << Invitation.create!(guest: guests[i], event: event, invitation_group: invitation_group) }
      }
      invitation_group.save!
      total_succeeded += 1
    rescue ActiveRecord::RecordInvalid  => e
      puts "Failed to process: "
      ap row
      ap e
      total_failed += 1
    rescue NoMethodError  
    end
  }
end

puts "total failed imports: #{total_failed}"
puts "total succeeded imports: #{total_succeeded}"
