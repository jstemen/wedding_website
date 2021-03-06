describe 'The site\'s static pages', :type => :feature do

  it "should include the Save The Date Game" do
    visit url_for save_the_date_path
    expect(find('#phaser-game')).not_to be_nil
  end

  it "should include The Non Indian\'s Guide'" do
    visit url_for non_indian_guide_path
    expect(page).to have_content('A Non Indian\'s Guide to a Hindu Wedding')
  end

  it "should include Home page'" do
    visit root_path
    expect(page).to have_content('About the Groom')
  end

end
