class CreateInvitationGroups < ActiveRecord::Migration
  def change
    create_table :invitation_groups do |t|
      t.string :code
      t.integer :max_guests

      t.timestamps
    end
    add_index :invitation_groups, :code, unique: true
    add_reference :invitations, :invitation_group, index: true
  end
end
