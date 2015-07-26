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


  it "A signed in admin should be able to access the invitations index page" do

    expect(page).to have_content('Total Invitation Group Count')
  end

  it "We can delete invitations from the edit invitations page" do
    invitation_group = create(:invitation_group, :five_guests)

    visit edit_invitations_path invitation_group.id

    Event.all { |event|
      invitation_group.guests { |guest|
        node = find("#event_to_guests_#{guest.id}-#{event.id}")
        expect(node.value).to eq("10")
      }
    }

  end

end
