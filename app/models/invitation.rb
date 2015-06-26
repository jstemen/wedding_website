class Invitation < ActiveRecord::Base
  belongs_to :guest
  belongs_to :invitation_group
  belongs_to :event
  validates :event, presence: true
  validates :invitation_group, presence: true
  accepts_nested_attributes_for :guest

end
