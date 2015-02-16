class CreateInvitationJoinTable < ActiveRecord::Migration
  def change
    create_join_table :guests, :invitations do |t|
      # t.index [:guest_id, :invitation_id]
      t.index [:invitation_id, :guest_id]
    end
  end
end
