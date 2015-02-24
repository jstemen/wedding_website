class RemoveGuestIdIdAndInvitationIdIdFromInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :guest_id, :string
    remove_column :invitations, :invitation_id, :string
  end
end
