class AddInvitationGroupReferenceToGuest < ActiveRecord::Migration
  def change
    add_reference :guests, :invitation_group, index: true
  end
end
