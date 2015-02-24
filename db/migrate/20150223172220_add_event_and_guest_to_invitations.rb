class AddEventAndGuestToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :event, index: true
    add_reference :invitations, :guest, index: true
  end
end
