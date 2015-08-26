class SendEmailJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    raise "the job is #{job.inspect}"
  end

  def perform(invitation_group)
    ReminderMailer.reminder_email(g).deliver_later
  end
end
