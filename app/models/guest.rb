class Guest < ActiveRecord::Base
  has_many :invitations
  has_many :events, through: :invitations

  validates :first_name, :last_name, presence: true

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, allow_blank: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
