require 'rails_helper'

RSpec.describe Invitation, :type => :model do

  it "may not have more than one event" do
    invitation = create(:invitation)
    expect {invitation.events << create(:event)}.to raise_error
  end

  it "must have an event" do
    invitation = build(:invitation, event: nil)
    expect {invitation.save!}.to raise_error
  end

  it "must have an invitation group" do
    invitation = build(:invitation, invitation_group: nil)
    expect {invitation.save!}.to raise_error
  end

  it "must not allow more guests than max_guests" do
    max_guests = 2
    invitation = build(:invitation)
    invitation.invitation_group.max_guests = max_guests
    (max_guests +5).times {
      invitation.guests << build(:guest)
    }
    expect{invitation.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "allows guests to max_guests" do
    max_guests = 2
    invitation = build(:invitation)
    invitation.invitation_group.max_guests = max_guests
    (max_guests).times {
      invitation.guests << build(:guest)
    }
    invitation.save!
  end
  
  it "must have an invitation group" do
    invitation = build(:invitation, invitation_group: nil)
  end

end
