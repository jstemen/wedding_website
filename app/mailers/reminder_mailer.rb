class ReminderMailer < ApplicationMailer
  helper :invitation_groups

  def reminder_email(guest)
    @guest = guest
    mail(to: guest.email_address, subject: "We're Looking Forward to Celebrating with You!")
  end
end
