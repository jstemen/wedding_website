class ReminderEmailsController < ApplicationController

  def index
    @pending_emails = ReminderEmail.where(sent_date: nil)
    @sent_emails = ReminderEmail.where.not(sent_date: nil).order(:sent_date)
  end

  def send_email_reminders
    InvitationGroup.all.each { |ig|
      ReminderMailer.reminder_email(ig).deliver_later
    }
    redirect_to 'index'
  end


end
