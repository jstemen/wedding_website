class InvitationGroup < ActiveRecord::Base
  validates :is_confirmed, :inclusion => {:in => [true, false]}
  validates :code, presence: true

  has_many :invitations, dependent: :destroy
  has_many :associated_guests, class_name: Guest

  accepts_nested_attributes_for :invitations


  def invitations_sorted_by_event
    invitations.sorted_by_event
  end

  def self.generate_random_code
    pool_array =[('A'..'Z'), (0..9)].inject { |a, b| a.to_a + b.to_a }
    code = (0..7).map { pool_array[rand(pool_array.size)] }.join
    code
  end

  def has_attendees
    not accepted_attendees.empty?
  end

  def accepted_attendees
    find_accepted_guests invitations
  end

  def accepted_attends_for(event)
    Guest.joins(invitations: [:guest, :event, :invitation_group]).where('invitation_groups.id' => id, 'events.id' => event.id, 'invitations.is_accepted' => true)

  end

  def guests
    res = (invitations.collect(&:guest) + self.associated_guests).flatten.compact.uniq.to_a
    res
  end

  def guest_names
    res = guests.collect(&:full_name).join(', ')
    res
  end

  private

  def find_accepted_guests(invitations)
    invitations.select(&:is_accepted).collect(&:guest).uniq.compact
  end
end

