class Guest < ActiveRecord::Base
  belongs_to :invitation
  validates :first_name, :last_name, presence: true

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, allow_blank: true
end
