class Invitation < ActiveRecord::Base
  attr_reader :should_keep
  belongs_to :guest
  belongs_to :invitation_group
  belongs_to :event
  validates :event, presence: true
  validates :invitation_group, presence: true
  accepts_nested_attributes_for :guest

  validates :should_keep, inclusion: [true]

  scope :sorted_by_event, -> { includes(:event).order('events.time ASC', 'events.name ASC') }
  scope :sorted_by_guest, -> { includes(:guest).order('guests.first_name ASC', 'guests.last_name ASC') }

  after_find do |inv|
    @should_keep = true
  end

end
