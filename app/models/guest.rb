class Guest < ActiveRecord::Base
  has_many :invitations
  has_many :events, through: :invitations
  belongs_to :invitation_group

  validates :first_name, presence: true

  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, allow_blank: true
  
  def full_name
    res ="#{first_name} #{last_name}"
    res
  end
end
