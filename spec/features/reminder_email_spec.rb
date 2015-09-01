describe 'When using reminder emails', :type => :feature do
  include ActiveJob::TestHelper, ApplicationHelper

  def send_reminder_emails_button_visible?
    page.has_button?('Send Reminder Emails')
  end

  it 'a non logged in user can not access the email index page' do
    visit reminder_emails_url
    expect(send_reminder_emails_button_visible?).to be(false)
  end


  it 'a logged in user can access the email index page' do
    login_admin
    visit reminder_emails_url
    expect(send_reminder_emails_button_visible?).to be(true)
  end

  context 'if the admin clicks the "send email" button' do
    before do
      @invitation_group = create(:invitation_group, :five_guests)
      @invitation = @invitation_group.invitations.last
      @invitation.is_accepted = true
      @invitation.save!
      @invitation_group.save!
      login_admin
      visit reminder_emails_path
      expect(send_reminder_emails_button_visible?).to be(true)
    end


    it 'we are redirected to the reminder emails index page' do
      click_button 'email-submit'
      expect(send_reminder_emails_button_visible?).to be(true)
    end

    context 'sent emails have' do
      before do
        perform_enqueued_jobs do
          assert_performed_jobs 0
          click_button 'email-submit'
          assert_performed_jobs 1
        end
      end
      it 'The guest\'s first name' do
        expect(page).to have_content(@invitation.guest.first_name)
      end
      it 'The guest\'s last name' do
        expect(page).to have_content(@invitation.guest.last_name)
      end
      it 'The event name' do
        expect(page).to have_content(@invitation.event.name)
      end
      it 'The event address' do
        expect(page).to have_content(@invitation.event.address)
      end
      it 'The event time' do
        expect(page).to have_content(render_time(@invitation.event.time))
      end

    end

  end

end
