class RemoveEventIdAndGuestIdFromInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :guest_id, :string
    remove_column :invitations, :event_id, :string
  end
end
