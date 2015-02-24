class AddReferencesToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :guest_id, index: true
    add_reference :invitations, :invitation_id, index: true
  end
end
