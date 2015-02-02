class InvitationGroup < ActiveRecord::Base
  validates :code, presence: true
  validates :max_guests, numericality: true, presence: true
  
  has_many :invitations
end
