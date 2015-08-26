module InvitationGroupsHelper
  include ApplicationHelper

  def print_attending(invitations)
    guests = invitations.select(&:is_accepted).collect(&:guest).collect(&:full_name).join(", ")
    guests.empty? ? 'none' : guests
  end

  def generate_key(event:, guest:)
    "#{guest.id}-#{event.id}"
  end

  def extract_event_and_guest(key)
    out= key.split('-')
    guest_id = out.first
    event_id = out.last
    [Event.find(event_id), Guest.find(guest_id)]
  end

end
