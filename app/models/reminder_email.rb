class ReminderEmail < ActiveRecord::Base
  belongs_to :invitation_group
  #body
  #sent_date
end