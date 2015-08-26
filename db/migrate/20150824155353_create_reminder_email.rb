class CreateReminderEmail < ActiveRecord::Migration
  def change
    create_table :reminder_emails do |t|
      t.string :body
      t.string :addresses
    end
  end
end