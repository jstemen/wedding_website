require 'rails_helper'

RSpec.describe InvitationGroup, :type => :model do
  it "has code" do
    invitation_group = create :invitation_group
    expect(invitation_group.code).to be_instance_of(String)
  end

  it "has confirmed" do
    invitation_group = create :invitation_group
    invitation_group.is_confirmed
  end

  it "has confirmed that can't be nil" do
    expect { create(:invitation_group, {is_confirmed: nil}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "must have code" do
    expect { create(:invitation_group, {code: ''}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "must delete associated invitations on delete" do
    invitation_group = create(:invitation_group)
    invitations = invitation_group.invitations
    invitation_group.destroy
    invitations.each{|invitation|
      expect( Invitation.exists?(invitation)).to be(false)
    }

  end

  it "can have code" do
    create(:invitation_group, {code: 'foobar'})
  end
  
  it "must have max_guests" do
    expect { create(:invitation_group, {max_guests: ''}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "must not allow string max_guests" do
    expect { create(:invitation_group, {max_guests: 'dog'}) }.to raise_error ActiveRecord::RecordInvalid
  end
  
  it "has max_guests" do
    invitation_group = create :invitation_group
    expect(invitation_group.max_guests).to be_instance_of(Fixnum)
  end
end
