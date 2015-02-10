# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Guest RSVPs' do

  scenario 'and clicks "Continue To Events Page" link.  They are taken to the Events page' do
    invitation_group = create :invitation_group
    guest = create :guest
    visit add_guests(invitation_group.code)
    click_link 'events_page'
    expect(page).to have_content 'Please select which guests will be attending which events.'
  end

  scenario 'and adds a new user to their invitation group' do
    invitation_group = create :invitation_group
    guest = create :guest
    visit add_guests(invitation_group.code)
    submited_guests = []
    submited_guests << fill_in_guest_submit("//form/ul/li")
    4.times { submited_guests << fill_in_guest_submit("//form/ul/li[last()]") }

    after_guests = invitation_group.guests
    expect(submited_guests.size).to be(after_guests.size)

    #redefine equals to only look at first and last name
    after_guests.each { |guest|
      def guest.==(other)
        self.first_name == other.first_name && self.last_name == other.last_name ? true : false
      end
    }

    submited_guests.each { |guest|
      expect(after_guests).to include(guest)
    }
  end

  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'by visiting the home page and entering a invitation code' do
    visit root_path
    invitation_group = create :invitation_group
    fill_in('code', :with => invitation_group.code)
    click_button 'Lookup'
    expect(page).to have_content 'Please Enter The Guests That Will Be Coming:'
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



end
