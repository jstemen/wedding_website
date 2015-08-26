class AddSentDateToReminderEmails < ActiveRecord::Migration
  def change
    add_column :reminder_emails, :sent_date, :date
  end
end
