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

  it "must have first_name" do
    expect{create(:guest, {first_name: ''})}.to raise_error ActiveRecord::RecordInvalid
  end
  
  it "has email_address" do
    guest = create :guest
    expect(guest.email_address).to be_instance_of(String)
  end

  it "has unique email_address" do
    guest = create :guest, email_address: 'jared@gmail.com'
    expect{create :guest, email_address: 'jared@gmail.com'}.to raise_error ActiveRecord::RecordNotUnique
  end
  
  it "has many invitations" do
    guest = create :guest
    invitation_one = create :invitation
    invitation_two = create :invitation
    guest.invitations << invitation_one
    guest.invitations << invitation_two
    guest.save
    expect(guest.invitations).to include(invitation_one)
    expect(guest.invitations).to include(invitation_two)
    expect(invitation_one.guest).to eq(guest)
    expect(invitation_two.guest).to eq(guest)
  end
  
  it "will not allow bad email" do
    expect{create(:guest, :bad_email)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "will allow no email" do
    create(:guest, :no_email)
  end
  
end
