class Invitation < ActiveRecord::Base
  has_many :guests
  belongs_to :invitation_group
  belongs_to :event
  
  validates :event, presence: true
  validates :invitation_group, presence: true
  
=begin

  validate :guests, :invitation_must_be_less_than_max

  
  def invitation_must_be_less_than_max
    max_guests = self.max_guests || 0
    if guests.size > max_guests
      errors.add(:guests, "You've exceeded your max number of allowed guest: #{max_guests}")
    end
  end
=end
end
