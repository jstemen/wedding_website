class InvitationGroup < ActiveRecord::Base
  validates :is_confirmed, :inclusion => {:in => [true, false]}
  validates :code, presence: true

  has_many :invitations, dependent: :destroy

  accepts_nested_attributes_for :invitations

  def has_attendees
    not accepted_attendees.empty?
  end

  def accepted_attendees
    invitations.select(&:is_accepted).collect(&:guest).uniq.compact
  end
end

