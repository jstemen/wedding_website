describe 'The admin process', :type => :feature do

  it "A signed in admin should be able to access the invitations index page" do
    pass = '123abc' * 2
    admin = create :admin, {password: pass}

    visit invitation_groups_url

    expect(page).to have_content('Log in')

    fill_in('admin_email', :with => admin.email)
    fill_in('admin_password', :with => pass)
    click_button 'Log in'

    expect(page).to have_content('Total Invitation Group Count')
  end

end
