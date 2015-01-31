require 'rails_helper'

RSpec.describe Invitation, :type => :model do
  it "has code" do
    invitation = create :invitation
    expect(invitation.code).to be_instance_of(String)
  end

  it "has max_guests" do
    invitation = create :invitation
    expect(invitation.max_guests).to be_instance_of(Fixnum)
  end
end
