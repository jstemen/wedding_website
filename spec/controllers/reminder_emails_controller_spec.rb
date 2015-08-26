require 'spec_helper'

describe ReminderEmailsController do

  describe '#send_email_reminders' do
    before do
      @invitation_group = create(:invitation_group, :five_guests)
      clazz = double 'ReminderMailer mock'
      fake_mail = double 'mail mock'
      InvitationGroup.all.each { |ig|
        expect(clazz).to receive(:reminder_email).with(ig).and_return(fake_mail)
        expect(fake_mail).to receive(:deliver_later)
      }
      stub_const("ReminderMailer", clazz)
      post(:send_email_reminders)
    end

    it 'should call reminder_email for every invitation group' do
      # see setup mocks for assertions
    end

    it 'should redirect' do
      expect(response.status).to eq(302)
    end
  end

end
