require 'rails_helper'

RSpec.describe Admin, :type => :model do
  before do
    @admin = create(:admin)
  end
  it 'has an email' do
    expect(@admin.email).not_to be(nil)
  end
  it 'has a password' do
    expect(@admin.password).not_to be(nil)
  end
end
