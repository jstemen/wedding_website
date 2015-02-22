class InvitationGroup < ActiveRecord::Base
  validates :is_confirmed, :inclusion => {:in => [true, false]}
  validates :code, presence: true
  validates :max_guests, numericality: true, presence: true

  has_many :invitations,  dependent: :destroy
  has_many :guests, dependent: :destroy

  accepts_nested_attributes_for :guests
  accepts_nested_attributes_for :invitations

  def has_attendees
     not invitations.collect(&:guests).empty?
  end
end

