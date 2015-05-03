require_relative '../features/feature_spec_helper'

describe 'The Save The Date Game', :type => :feature, :js => true do

  xit "should render on the page", :driver => :webkit do
    puts " driver is #{Capybara.current_driver} "
    visit url_for save_the_date_path
    expect(find('#phaser-game > canvas')).not_to be_nil
  end

end
