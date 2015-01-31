class Invitation < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_many :guests

  validates :code, presence: true
  validates :max_guests, numericality: true, presence: true
end
