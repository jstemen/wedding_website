def generate_guest_test(action, button_name, path)
  pasted_tense_action = "#{action}d"
  describe "when a guest is #{pasted_tense_action}" do
    before do
      invitation_group = create(:invitation_group, :five_guests)
      visit send(path, invitation_group.id, invitation_group.guests.first.id)
      @first_name = 'John'
      @last_name = 'Doe'
      fill_in :guest_first_name, :with => @first_name
      fill_in :guest_last_name, :with => @last_name
    end
    it "#{action}s a guest" do
      click_button button_name
      expect(Guest.where(first_name: @first_name, last_name: @last_name).size).to eq(1)
    end

    #We don't want empty email addresses because we have a uniqueness constraint on the email address
    it "#{action}s a guest with a blank email address sets the email as nil" do
      fill_in :guest_email_address, :with => ''
      click_button button_name
      expect(Guest.where(first_name: @first_name, last_name: @last_name).first.email_address).to be_nil
    end

    it "take the admin back to the invitations edit page after #{action}ing a guest" do
      click_button button_name
      expect(page).to have_content('Edit Invitations')
    end

    context "with bad input" do
      before do
        @bad_email = "im not an email address"
        fill_in :guest_email_address, :with => @bad_email
        click_button button_name
      end

      it "does not #{action} when the guest has a bad email address" do
        expect(Guest.where(first_name: @first_name, last_name: @last_name)).to be_empty
      end
      it 'keeps the bad data on the screen so the user can fix it' do
        expect(find('#guest_email_address').value).to eq(@bad_email)
      end
    end
  end
end

describe 'The admin process', :type => :feature do

  before do
    login_admin
  end

  after do |scenario|
    if scenario.exception
      #save_and_open_page
    end
  end

  context "on the invtation groups index page" do
    it 'A signed in admin should be able to access the invitations index page' do
      expect(page).to have_content('Total Invitation Group Count')
    end

    context 'clicking the invitation group code should take the admin to the show events page' do

      before do
        @invitation_group = create(:invitation_group, :five_guests)
        visit invitation_groups_path
      end

      it 'and allow the admin to change the rsvp when it is not confirmed' do
        click_link @invitation_group.code
        expect(page).to have_content 'Please select which guests will be attending each event.'
      end

      it 'and allow the admin to change the rsvp when it is confirmed' do
        @invitation_group.is_confirmed = true
        @invitation_group.save!
        verify_that_invitation_groups_rsvps_can_be_modified @invitation_group, 'thank_you'
      end
    end

    it "creates a new invitation group when the admin clicks on \"Create new Invtation Group\"" do
      @invitation_group = create(:invitation_group, :five_guests)
      before_count = InvitationGroup.count
      click_button "Create new Invtation Group"
      after_count = InvitationGroup.count
      expect(after_count).to eq(before_count +1)
      #todo fix the fact that we get more than one empty link back
      #click_link "empty"
      click_link "empty", :match => :first
      expect(page).to have_content 'Edit Invitation'
    end
  end

  describe 'editing invitations' do
    before do
      @invitation_group = create(:invitation_group, :five_guests)
      @guest = @invitation_group.guests.sample
      @fresh_event = create(:event)
      @assocated_guest = create(:guest)
      @invitation_group.associated_guests << @assocated_guest
      visit edit_invitations_path @invitation_group.id
      @node = find "#event_to_guests_#{@guest.id}-#{@fresh_event.id}"

    end

    it 'shows associated guests' do
      expect(page).to have_content @assocated_guest.full_name
    end

    it 'takes the user to the new guest page when the user clicks the link' do
      click_link 'Create Guest'
      expect(page).to have_content 'Create Guest'
    end

    it 'takes the user to the edit guest page when the user clicks the link' do
      click_link @guest.full_name, :match => :first
      expect(page).to have_content 'Update Guest'
    end

    [true, false].each { |confirmed|
      it "allows an admin to create and invitation with is confirmed: #{confirmed}" do
        @node.set(true)
        @invitation_group.is_confirmed = confirmed
        click_button 'Save'

        invited = guest_invited_to_event? event: @fresh_event, guest: @guest
        expect(invited).to be(true)
        expect(page).to have_content 'Successfully updated invitation group!'
        expect(page).to have_content 'Total Finalized Invitation Group Count'
      end
    }
    it 'allows the admin to delete an invitation' do
      @node.set(false)
      click_button 'Save'

      invited = guest_invited_to_event? event: @fresh_event, guest: @guest
      expect(invited).to be(false)
      expect(page).to have_content 'Successfully updated invitation group!'
      expect(page).to have_content 'Total Finalized Invitation Group Count'
    end
  end


  it 'is presented with a set of checkboxes that is consistent with the database' do
    invitation_group = create(:invitation_group, :five_guests)

    visit edit_invitations_path invitation_group.id

    Event.all.each { |event|
      invitation_group.guests.each { |guest|
        node = find("#event_to_guests_#{guest.id}-#{event.id}")
        if guest_invited_to_event? guest: guest, event: event
          expect(node).to be_checked
        else
          expect(node).to_not be_checked
        end
      }
    }

  end


  it 'does not allow admin to create a guest without a first name' do
    invitation_group = create(:invitation_group, :five_guests)
    visit new_invitation_group_guest_path invitation_group.id

    last_name = 'Doe'
    fill_in :guest_last_name, :with => last_name

    click_button 'Create Guest'
    expect(Guest.where(last_name: last_name)).to be_empty
  end


  generate_guest_test 'create', 'Create Guest', :new_invitation_group_guest_path
  generate_guest_test 'edit', 'Update Guest', :edit_invitation_group_guest_path


  def guest_invited_to_event?(event:, guest:)
    size = Invitation.where(event: event, guest: guest).size
    size > 0
  end

end
