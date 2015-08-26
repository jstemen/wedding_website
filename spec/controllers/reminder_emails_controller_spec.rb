require 'spec_helper'

describe ReminderEmailsController do

  describe '#send_email_reminders' do


    context 'when emails are succesfully sent' do

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

      it 'should flash a success message ' do
        expect(flash[:success]).to eq('Emails have successfully been enqueue to be sent')
      end
    end


    context 'when there are still jobs in the job queue' do
      before do
        mock_job_clazz = double "job clazz"
        mock_job = double "job"
        expect(mock_job_clazz).to receive(:all).and_return([mock_job])
        stub_const("Delayed::Job", mock_job_clazz)
        post(:send_email_reminders)
      end
      it 'should raise and error when there are still queued up jobs' do
        expect(response.status).to eq(302)
      end
      it 'should flash a failure message ' do
        expect(flash[:error]).to eq('Background jobs are still being processed.  Please try again later!')
      end
    end
  end

end
