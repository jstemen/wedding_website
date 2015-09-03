describe 'The RSVP Process', :type => :feature do

  invalid_code = 'I am not a valid code'
  error_msg = "You have entered the invalid RSVP code: \"#{invalid_code}\".  If you believe that you have received this message in error, please contact us via palakandjared@gmail.com, or call Veena at 678-232-4506."
  it "If a user enters an invalid invitation group code on the home page, they receive the error message: #{error_msg}" do
    visit root_path
    invitation_group = create :invitation_group
    fill_in('code', :with => invalid_code)
    click_button 'Lookup'
    expect_to_be_on_home_page
    expect(page).to have_content error_msg
  end

  reuse_error_msg = 'We have already received your RSVP.  Please contact palakandjared@gmail.com, or call Veena at 678-232-4506 with any questions.'
  context 'If a user tries to reuse a code from am a confirmed invitation group,' do
    before do
      @invitation_group = create(:invitation_group, :five_guests, with_accepted_invitations: true, is_confirmed: true)
      visit link_guests_to_events(@invitation_group.code)
      expect_to_be_on_events_page
      @accepted_invitations = @invitation_group.invitations
    end

    it "they get the error message #{reuse_error_msg}" do
      expect(page).to have_content reuse_error_msg
    end

    context "they see a list of events their party RSVP'd to" do
      it_behaves_like 'email table'
    end
  end


  is_coming = "We look forward to celebrating with you!"
  it "Thank-you page should say '#{is_coming}' when there is at least one guest attending" do
    invitation_group = create(:invitation_group, :five_guests)
    invitation = invitation_group.invitations.first
    invitation.is_accepted = true
    invitation_group.save!
    invitation.save!
    visit link_thank_you(invitation_group.code)
    expect_to_be_on_thank_you_page
    expect(page).to have_content is_coming
  end

  not_coming = "We're sorry to miss you!"
  it "Thank-you page should say '#{not_coming}' when there are no guests attending" do
    invitation_group = create(:invitation_group, :five_guests)
    visit link_thank_you(invitation_group.code)
    expect_to_be_on_thank_you_page
    expect(page).to have_content not_coming
  end

  it 'Upon clicking the "Back" button on the confirmation page, guests are taken back to the events page' do
    invitation_group = create(:invitation_group, :five_guests)

    visit link_confirmation(invitation_group.code)
    click_link('Back')
    expect_to_be_on_events_page
  end


  it 'Upon clicking the "Confirm RSVP" button on the confirmation page, guests are taken to the thank-you page' do
    invitation_group = create(:invitation_group, :five_guests)

    visit link_confirmation(invitation_group.code)

    click_button 'confirmRsvp'
    expect_to_be_on_thank_you_page
  end


  it 'users can see their existing RSVPs on the events page' do
    invitation_group = create(:invitation_group, :five_guests)


    expected_selected_arry = invitation_group.invitations.sample(invitation_group.invitations.size/2)
    expected_selected_arry.each { |i|
      i.is_accepted=true
      i.save!
    }


    visit link_guests_to_events(invitation_group.code)

    expect_to_be_on_events_page
    expected_selected_arry.each { |invitation|
      #ToDo id in html seems to be zero based ... investigate
      node = find("#invitation_group_invitations_attributes_#{invitation.id-1}_is_accepted")
      expect(node.value).to eq("1")
    }
    expect(page.all("[checked]").size).to eq(expected_selected_arry.size)

  end


  it 'users can select guests and be sent to the confirmation page' do
    invitation_group = create(:invitation_group, :five_guests)

    verify_that_invitation_groups_rsvps_can_be_modified(invitation_group)
  end

  it 'users can go to the events page by entering their invitation code on the home page' do
    visit root_path
    invitation_group = create :invitation_group
    fill_in('code', :with => invitation_group.code)
    click_button 'Lookup'
    expect_to_be_on_events_page
  end

  private

  def fill_in_guest_submit(selector)
    guest = build :guest
    within(:xpath, selector) do
      fill_in 'First name', :with => guest.first_name
      fill_in 'Last name', :with => guest.last_name
    end
    click_button 'Update Invitation group'
    guest
  end


end
