class InvitationGroup < ActiveRecord::Base
  validates :code, presence: true
  validates :max_guests, numericality: true, presence: true

  has_many :invitations,  dependent: :destroy
  has_many :guests

  accepts_nested_attributes_for :guests
  accepts_nested_attributes_for :invitations
end

