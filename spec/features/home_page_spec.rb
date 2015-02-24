describe 'The RSVP Process', :type => :feature do

  error_msg = 'You have entered an invalid RSVP code.  If you believe that you have received this message in error, please contact palakandjared@gmail.com'
  it "If a user enters an invalid invitation group code on the home page, they receive the error message: #{error_msg}" do
    visit root_path
    invitation_group = create :invitation_group
    fill_in('code', :with => 'I am not a valid code')
    click_button 'Lookup'
    expect_to_be_on_home_page
    expect(page).to have_content error_msg
  end

  reuse_error_msg = 'We have already received your RSVP.  Please contact palakandjared@gmail.com with any questions.'
  it "If a user tries to reuse a code from am a confirmed invitation group, they get the error message #{reuse_error_msg}" do
    invitation_group = create(:invitation_group, :five_guests, is_confirmed: true)
    visit link_guests_to_events(invitation_group.code)
    expect_to_be_on_events_page
    expect(page).to have_content reuse_error_msg
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

    expected_selected_arry.each{|invitation|
      node  = find("#invitation_group_invitations_attributes_#{invitation.id}_is_accepted")
      expect(node.value).to eq("1")
    }
    expect(page.all("[checked]").size).to eq(expected_selected_arry.size)

  end


  it 'users can select guests and be sent to the confirmation page' do
    invitation_group = create(:invitation_group, :five_guests)

    visit link_guests_to_events(invitation_group.code)

    invitations = invitation_group.invitations

    invitations.each { |inv|
      check "#invitation_group_invitations_attributes_#{inv.id}_is_accepted"
    }

    click_button 'submitSaveGuestSelections'

    redefine_equals invitations, :last_name, :first_name
    expect_to_be_on_confirmation_page
    #Need to look up IG from db to get updated copy
    inv_guests = InvitationGroup.find(invitation_group.id).invitations.first.guests.to_a

    expect(inv_guests).to include(*invitations)

  end

  it 'users can go to the events page by entering their invitation code on the home page' do
    visit root_path
    invitation_group = create :invitation_group
    fill_in('code', :with => invitation_group.code)
    click_button 'Lookup'
    expect_to_be_on_events_page
  end

  private

  def redefine_equals(objs, *args)
    #redefine equals to only look at first and last name
    my_args = args
    # Ruby doesn't like passing variables to inner method, so we'll abuse eval
    code = "" "
    objs.each { |obj|
      def obj.==(other)
        comp = true
        #{my_args.inspect}.each{|arg|
          if self.send(arg) != other.send(arg)
            comp= false
            break
          end
        }
        comp
      end
    }
    " ""
    eval code

  end

  def fill_in_guest_submit(selector)
    guest = build :guest
    within(:xpath, selector) do
      fill_in 'First name', :with => guest.first_name
      fill_in 'Last name', :with => guest.last_name
    end
    click_button 'Update Invitation group'
    guest
  end

  def add_guests(code)
    "/invitation_groups/show/#{code}/guests"
  end

  def link_guests_to_events(code)
    "/invitation_groups/show/#{code}/events"
  end

  def link_confirmation(code)
    "/invitation_groups/confirmation?code=#{code}"
  end

  def link_thank_you(code)
    "/invitation_groups/show/#{code}/thank_you"
  end

  def expect_to_be_on_events_page
    expect(find('#eventsSelectionPage')).not_to be_nil
  end

  def expect_to_be_on_confirmation_page
    expect(find('#confirmationPage')).not_to be_nil
  end

  def expect_to_be_on_home_page
    expect(find('#homePage')).not_to be_nil
  end

  def expect_to_be_on_thank_you_page
    expect(find('#thankYouPage')).not_to be_nil
  end

end
