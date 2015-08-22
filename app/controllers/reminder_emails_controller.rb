class ReminderEmailsController < ApplicationController
  def send_email_reminders
    Guest.all.each { |g|
      SendEmailJob.set(wait: 20.seconds).perform_later(g)
    }
  end
end
