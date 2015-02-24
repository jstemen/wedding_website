class InvitationGroup < ActiveRecord::Base
  validates :is_confirmed, :inclusion => {:in => [true, false]}
  validates :code, presence: true

  has_many :invitations,  dependent: :destroy

  accepts_nested_attributes_for :invitations

  def has_attendees
     guests = invitations.select(&:is_accepted).collect(&:guest).compact
     not guests.empty?
  end
end

