
describe "The RSVP Process", :type => :feature do

  xit 'Upon clicking the "Back" button on the confirmation page, guests are taken back to the events page'
  xit 'Upon clicking the "Confirm RSVP" button on the confirmation page, guests are taken to the thank-you page'

  it 'users can see their existing RSVPs on the events page' do
    invitation_group = create(:invitation_group, :five_guests, :four_invitations)


    expected_selected_arry = invitation_group.invitations.collect { |inv|
      guests_sample = invitation_group.guests.sample 2
      inv.guests = guests_sample
      inv.save!
      guests_sample
    }

    visit link_guests_to_events(invitation_group.code)

    expected_selected_arry.each_with_index { |inv_guests, i|
      within("#invitation_group_invitations_attributes_#{i}_guests_input") do
        selected_guest_ids =page.all("[checked]").collect{|t|t.value.to_i}
        expected_guest_ids = inv_guests.collect &:id
        expect(selected_guest_ids.size).to eq(expected_guest_ids.size)
        expect(selected_guest_ids).to include *expected_guest_ids
      end

    }
  end


  it 'users can select guests and be sent to the confirmation page' do
    invitation_group = create(:invitation_group, :five_guests, :four_invitations)

    visit link_guests_to_events(invitation_group.code)

    group_guests = invitation_group.guests

    group_guests.each { |guest|
      check "invitation_group_invitations_attributes_0_guest_ids_#{guest.id}"
    }

    click_button 'submitSaveGuestSelections'

    redefine_equals group_guests, :last_name, :first_name
    expect_to_be_on_confirmation_page
    #Need to look up IG from db to get updated copy
    inv_guests = InvitationGroup.find(invitation_group.id).invitations.first.guests.to_a

    expect(inv_guests).to include(*group_guests)

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

  def expect_to_be_on_events_page
    expect(find('#eventsSelectionPage')).not_to be_nil
  end

  def expect_to_be_on_confirmation_page
    expect(find('#confirmationPage')).not_to be_nil
  end

  def expect_to_be_on_thank_you_page
    expect(find('#thankYouPage')).not_to be_nil
  end

end
