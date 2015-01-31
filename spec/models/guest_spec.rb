require 'rails_helper'

RSpec.describe Guest, :type => :model do
  it "has first_name" do
    guest = create :guest
    expect(guest.first_name).to be_instance_of(String)
  end

  it "has last_name" do
    guest = create :guest
    expect(guest.last_name).to be_instance_of(String)
  end
  
  it "has email_address" do
    guest = create :guest
    expect(guest.email_address).to be_instance_of(String)
  end

  it "has unique email_address" do
    guest = create :guest
    expect{create :guest}.to raise_error ActiveRecord::RecordNotUnique
  end
  
  it "has one invitation" do
    guest = create :guest
    invitation = create :invitation
    guest.invitation = invitation
    guest.save
    expect(guest.invitation).to be(invitation)
    expect(invitation.guests).to include(guest)
  end
end
