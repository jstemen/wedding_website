# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
total_failed =0
total_succeeded =0
event_str_to_event = {
    'number_invited_guests_-_wedding' => Event.create!(name: 'Wedding', time: Date.new),
    'mehndi_invited' => Event.create!(name: 'Wedding', time: Date.new),
    'number_invited_guests_-_vidhi' => Event.create!(name: 'Wedding', time: Date.new),
    'number_invited_guests_-_after_party' => Event.create!(name: 'Wedding', time: Date.new)
}
event_sym_to_event = {}
event_str_to_event.each{|key,value|
  event_sym_to_event[key.to_s] = value
}

SmarterCSV.process('db/spreadsheet_data.csv', remove_empty_values: false) do |chunk|

  chunk.each { |row|
    begin
      code = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      invitation_group = InvitationGroup.new(code: code)
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
        count = row[event_sym] || 0
        (0..(count-1)).each { |i| invitation_group.invitations << Invitation.create!(guest: guests[i], event: event) }
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
