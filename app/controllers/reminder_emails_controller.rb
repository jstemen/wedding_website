class ReminderEmailsController < ApplicationController

  def index
    @pending_emails = ReminderEmail.where(sent_date: nil)
    @sent_emails = ReminderEmail.where.not(sent_date: nil).order(:sent_date)
  end

  def send_email_reminders

    if Delayed::Job.all.empty?
      InvitationGroup.all.each { |ig|
        ReminderMailer.reminder_email(ig).deliver_later
      }
    else
      flash[:error] = 'Background jobs are still being processed.  Please try again later!'
    end
      flash[:success] = 'Emails have successfully been enqueue to be sent'
      redirect_to 'index'

  end


end
