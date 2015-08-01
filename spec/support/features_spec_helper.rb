module FeaturesHelper
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

  def verify_that_invitation_groups_rsvps_can_be_modified(invitation_group, page_name='confirmation')
    visit link_guests_to_events(invitation_group.code)

    invitations = invitation_group.invitations

    expect_to_be_on_events_page
    invitations.each { |inv|
      #ToDo id in html seems to be zero based ... investigate
      check "invitation_group_invitations_attributes_#{inv.id-1}_is_accepted"
    }
    invited_guests = invitations.collect(&:guest)

    click_button 'submitSaveGuestSelections'

    redefine_equals invited_guests, :last_name, :first_name
    send "expect_to_be_on_#{page_name}_page"
    #Need to look up IG from db to get updated copy
    inv_guests = InvitationGroup.find(invitation_group.id).accepted_attendees

    expect(inv_guests).to include(*invited_guests)
  end
end
