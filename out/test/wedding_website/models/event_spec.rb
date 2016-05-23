require 'rails_helper'

RSpec.describe Event, :type => :model do
  it "has name" do
    event = create :event
    expect(event.name).to be_instance_of(String)
  end

  it "has time" do
    event = create :event
    expect(event.time).to be_instance_of(ActiveSupport::TimeWithZone)
  end

  it "has invitations" do
    event = create :event
    invitation = create :invitation
    event.invitations << invitation
    event.save!
    expect(event.invitations).to include(invitation)
    expect(invitation.event).to be(event)
  end

  it "can find_guests_coming" do
    invitation_group = create(:invitation_group, :five_guests)
    event = Event.all.first
    res = event.find_guests_coming
    expect(res).to_not be_nil
    expect(res).to_not be_empty

    res.each { |guest|
      expect(guest.full_name).to be_a(String)
    }
  end

end
