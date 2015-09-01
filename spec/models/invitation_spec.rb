require 'rails_helper'

RSpec.describe Invitation, :type => :model do

  it "may not have more than one event" do
    invitation = create(:invitation)
    expect {invitation.events << create(:event)}.to raise_error NoMethodError
  end

  it "must have an event" do
    invitation = build(:invitation, event: nil)
    expect {invitation.save!}.to raise_error ActiveRecord::RecordInvalid
  end

  it "must have an invitation group" do
    invitation = build(:invitation, invitation_group: nil)
    expect {invitation.save!}.to raise_error ActiveRecord::RecordInvalid
  end

  
  xit "must have an invitation group" do
    invitation = build(:invitation, invitation_group: nil)
  end

end
