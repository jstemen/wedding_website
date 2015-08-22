# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def reminder_email_preview
    ReminderMailer.reminder_email(Guest.first)
  end
end
