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
  
end
