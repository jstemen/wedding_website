class CreateEventJoinTable < ActiveRecord::Migration
  def change
    create_join_table :events, :invitations do |t|
      # t.index [:event_id, :invitation_id]
      t.index [:invitation_id, :event_id], unique: true
    end
  end
end
