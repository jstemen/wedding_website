require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  include InvitationGroupsHelper
  before do
    @invitation_group = create(:invitation_group, :four_invitations)
    @invitation = @invitation_group.invitations.first()
    @invitation.is_accepted = true
    @invitation.guest= create(:guest)
    @invitation.guest.save!
    @invitation_group.save!
    @guest = Guest.first
    @mail = ReminderMailer.reminder_email @invitation_group


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
    expect(@mail.to).to eql([@guest.email_address])
  end
  it 'renders the sender email' do
    expect(@mail.from).to eql(['palakandjared@gmail.com'])
  end

end
