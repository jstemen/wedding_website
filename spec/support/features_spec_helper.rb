module FeaturesHelper
  include ApplicationHelper

  def login_admin
    pass = '123abc' * 2
    admin = create :admin, {password: pass}

    visit invitation_groups_path

    expect(page).to have_content('Log in')

    fill_in('admin_email', :with => admin.email)
    fill_in('admin_password', :with => pass)
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end

  shared_examples_for 'email table' do
    context 'it shows each of the accepted invitations\' ' do

      it 'guest\'s first name' do
        @accepted_invitations.each { |inv|
          expect(page).to have_content(inv.guest.first_name)
        }
      end
      it 'guest\'s last name' do
        @accepted_invitations.each { |inv|
          expect(page).to have_content(inv.guest.last_name)
        }
      end
      it 'event name' do
        @accepted_invitations.each { |inv|
          expect(page).to have_content(inv.event.name)
        }
      end
      it 'event address' do
        @accepted_invitations.each { |inv|
          expect(page).to have_content(inv.event.address)
        }
      end
      it 'event time' do
        @accepted_invitations.each { |inv|
          expect(page).to have_content(render_time(inv.event.time))
        }
      end
    end

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
