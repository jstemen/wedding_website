require 'rails_helper'

RSpec.describe InvitationGroup, :type => :model do
  it "has code" do
    invitation_group = create :invitation_group
    expect(invitation_group.code).to be_instance_of(String)
  end

  it "must have code" do
    expect { create(:invitation_group, {code: ''}) }.to raise_error ActiveRecord::RecordInvalid
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
