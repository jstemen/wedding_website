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
    pass = '123abc' * 2
    admin = create :admin, {password: pass}

    visit invitation_groups_url

    expect(page).to have_content('Log in')

    fill_in('admin_email', :with => admin.email)
    fill_in('admin_password', :with => pass)
    click_button 'Log in'
  end

  after do |scenario|
    if scenario.exception
      #save_and_open_page
    end
  end


  it 'A signed in admin should be able to access the invitations index page' do
    expect(page).to have_content('Total Invitation Group Count')
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
      it "allows an admin to create and inviation with is confirmed: #{confirmed}" do
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
