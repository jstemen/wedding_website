describe 'When using reminder emails', :type => :feature do

  include ActiveJob::TestHelper

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

    ReminderEmailsController
    it 'we are redirected to the reminder emails index page' do
      click_button 'email-submit'
      expect(send_reminder_emails_button_visible?).to be(true)
    end

    it 'sent emails are displayed' do
      perform_enqueued_jobs do
        assert_performed_jobs 0
        click_button 'email-submit'
        assert_performed_jobs 1
      end
      expect(page).to have_content(@invitation.guest.first_name)
    end

  end
end
