require 'rails_helper'

RSpec.describe Invitation, :type => :model do
  it "has code" do
    invitation = create :invitation
    expect(invitation.code).to be_instance_of(String)
  end

  it "must have code" do
    expect { create(:invitation, {code: ''}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "must have max_guests" do
    expect { create(:invitation, {max_guests: ''}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "must not allow string max_guests" do
    expect { create(:invitation, {max_guests: 'dog'}) }.to raise_error ActiveRecord::RecordInvalid
  end

  it "has max_guests" do
    invitation = create :invitation
    expect(invitation.max_guests).to be_instance_of(Fixnum)
  end
end
