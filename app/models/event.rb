class Event < ActiveRecord::Base
  has_many :invitations
  has_many :guests, through: :invitations

  def find_guests_coming
    rel = Guest.joins(invitations: :event).where('events.name' => name)
    rel
  end
end
