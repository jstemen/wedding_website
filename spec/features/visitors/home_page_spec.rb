# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Guest RSVPs' do

  scenario 'can select guests' do
    invitation = create :invitation
    invitation_group = invitation.invitation_group
    5.times{
      guest = create(:guest)
      invitation_group.guests << guest
      guest.save!
    }
    invitation.save!
    invitation_group.save!
    
    visit link_guests_to_events(invitation_group.code)

    group_guests = invitation_group.guests
    
    group_guests.each{|guest|
      select(guest.full_name, :from => 'invitation_group_invitations_attributes_1_guest_ids')
    }
    
    click_button 'Update Invitation group'

    redefine_equals group_guests, :last_name, :first_name
    inv_guests = []
    count = 0
    while inv_guests.empty? && count < 60
      inv_guests = invitation_group.invitations.first.guests.to_a
      sleep 1
      count +=1
    end

    expect(inv_guests).to include(*group_guests)

  end
  
  
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

    redefine_equals after_guests, :last_name, :first_name

    submited_guests.each { |guest|
      expect(after_guests).to include(guest)
    }
  end
  
  def redefine_equals(objs,*args)
    #redefine equals to only look at first and last name
    my_args = args
    
    code = """
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
    """
    eval code
    
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
