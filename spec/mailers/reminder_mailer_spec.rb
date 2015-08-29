require 'pry'
require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  include InvitationGroupsHelper
  before do
    @invitation_group = create(:invitation_group, :four_invitations, with_accepted_invitations: true)
    @invitation_group.save!
    @invitation_group.invitations.first
    @invitation = @invitation_group.invitations.first
    @guest = @invitation.guest
    @mail = ReminderMailer.reminder_email @invitation_group
    expect(@mail).to_not be(nil)

  end
  it "should include the fullname of the guest" do
    expect(@mail.body.encoded).to include @invitation.guest.full_name
  end

  context "should include " do
    it "complete with event name" do
      expect(@mail.body.encoded).to include @invitation.event.name

    end
    it "complete with event time" do
      expect(@mail.body.encoded).to include render_time(@invitation.event.time)

    end

    it "complete with event address" do
      expect(@mail.body.encoded).to include @invitation.event.address

    end

    it 'renders the subject' do
      expect(@mail.subject).to eql("We're Looking Forward to Celebrating with You!")
    end
  end

  it 'renders the receiver email' do
    expect(@mail.to).to include(@guest.email_address)
  end
  it 'renders the sender email' do
    expect(@mail.from).to eql(['palakandjared@gmail.com'])
  end

end
