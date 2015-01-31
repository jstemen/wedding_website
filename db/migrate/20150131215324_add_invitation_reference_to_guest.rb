class AddInvitationReferenceToGuest < ActiveRecord::Migration
  def change
    add_reference :guests, :invitation, index: true
  end
end
