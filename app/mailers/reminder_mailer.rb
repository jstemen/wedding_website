class ReminderMailer < ApplicationMailer
  helper :invitation_groups

  def reminder_email(invitation_group)
    @event_to_attending_hash = Event.all.collect { |event|
      attending_guests = Guest.joins(:invitations).where(invitations: {event_id: event.id, invitation_group_id: invitation_group.id, is_accepted: true})
      [event, attending_guests]
    }.to_h

    my_mail = nil
    unless @event_to_attending_hash.collect { |k, v| v }.flatten.empty?
      addresses = invitation_group.guests.collect(&:email_address).join ', '
      my_mail = mail(to: addresses, subject: "We're Looking Forward to Celebrating with You!")
      ReminderEmail.new(addresses: addresses, invitation_group: invitation_group, sent_date: DateTime.now, body: my_mail.body).save!
    end
    my_mail
  end
end
