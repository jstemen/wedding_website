class SendEmailJob < ActiveJob::Base
  queue_as :default

  def perform(g)
    ReminderMailer.reminder_email(g).deliver_later
  end
end
