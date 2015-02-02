class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.timestamps
    end
    add_reference :invitations, :event, index: true
  end

end
