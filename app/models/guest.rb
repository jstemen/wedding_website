class Guest < ActiveRecord::Base
  belongs_to :invitation

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
end
