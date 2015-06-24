describe 'The admin process', :type => :feature do

  it "A singed in admin should be able to access the invitations index page" do
    pass = '123abc'
    admin = create :admin, {password: pass}

    visit invitation_groups_url
    expect(page).to have_content('Total Invitation Group Count')

=begin
    invitation_group = create(:invitation_group, :five_guests)
    invitation = invitation_group.invitations.first
    invitation.is_accepted = true
    invitation_group.save!
    invitation.save!
    visit link_thank_you(invitation_group.code)
    expect_to_be_on_thank_you_page
=end
  end

end
