module InvitationGroupsHelper

  def print_attending(invitations)
    guests = invitations.select(&:is_accepted).collect(&:guest).collect(&:full_name).join(", ")
    guests.empty? ? 'none' : guests
  end
end
