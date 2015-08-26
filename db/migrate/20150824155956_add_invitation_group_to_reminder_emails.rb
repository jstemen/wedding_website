class AddInvitationGroupToReminderEmails < ActiveRecord::Migration
  def change
    add_reference :reminder_emails, :invitation_group, index: true, foreign_key: true
  end
end
