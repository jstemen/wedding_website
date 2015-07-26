class AddInvitaitonGroupRerferenceToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :invitation_group_id, :integer
    add_index "guests", ["invitation_group_id"], name: "index_guests_on_invitation_group_id"
  end
end
