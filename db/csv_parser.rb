require 'smarter_csv'

event_strs = %w{number_invited_guests_-_wedding mehndi_invited number_invited_guests_-_vidhi number_invited_guests_-_after_party}.collect(&:to_s)
groups = []
SmarterCSV.process('./spreadsheet_data.csv', remove_empty_values: false) do |row|
  code = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  invitation_group = InvitationGroup.new(code: code)
  groups << invitation_group
  guests << Guest.create(first_name: row['First-Name-Primary'], last_name: row['Last-Name-Primary'])
  guests << Guest.create(first_name: row['First-Name-Secondary'], last_name: row['Last-Name-Secondary'])
  row['Children'].split(',').each { |c| guests << Guest.create(first_name: c) }
  event_strs.each { |event_str|
    count = row[event_str] || 0
    (1..count).collect { |i| Invitation.create(guest: guests[i], invitation_group: invitation_group) }
  }
  invitation_group.save!
end
