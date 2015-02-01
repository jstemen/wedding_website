class Invitation < ActiveRecord::Base
  include ActiveModel::Validations
  has_and_belongs_to_many :events
  has_many :guests
  validate :guests, :invitation_must_be_less_than_max
  validates :code, presence: true
  validates :max_guests, numericality: true, presence: true
  
  def invitation_must_be_less_than_max
    max_guests = self.max_guests || 0
    if guests.size > max_guests
      errors.add(:guests, "You've exceeded your max number of allowed guest: #{max_guests}")
    end
  end
end
