module InvitationGroupsHelper

  def print_attending(invitation)
    guests = invitation.guests.collect(&:full_name).join(', ')
     guests.empty? ? 'none' : guests
  end
end
