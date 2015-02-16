class Guest < ActiveRecord::Base
  has_and_belongs_to_many :invitations
  validates :first_name, :last_name, presence: true

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, allow_blank: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
