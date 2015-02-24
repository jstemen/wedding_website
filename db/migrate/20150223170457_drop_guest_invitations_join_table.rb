class DropGuestInvitationsJoinTable < ActiveRecord::Migration
  def change
    drop_join_table :guests, :invitations
  end
end
