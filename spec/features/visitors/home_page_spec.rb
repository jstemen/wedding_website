# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Guest RSVPs' do
  scenario 'and adds a new user to their invitation group' do
    invitation_group = create :invitation_group
    guest = create :guest
    invitation_group.guests << guest
    invitation_group.save!
    visit add_guests(invitation_group.code)
    before_count = invitation_group.guests.size
    out = find(:xpath, "//form/ul/li[last()]")
    within(:xpath, "//form/ul/li[last()]") do
      fill_in 'First name', :with => 'Jared'
      fill_in 'Last name', :with => 'Stemen'
    end
    click_button 'Update Invitation group'
    expect(page).to have_content 'Please Enter The Guests That Will Be Coming:'

    after_count = invitation_group.guests.size

    expect(before_count+1).to be(after_count)
  end

  def add_guests(code)
    "/invitation_groups/show/#{code}/guests"
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


end
