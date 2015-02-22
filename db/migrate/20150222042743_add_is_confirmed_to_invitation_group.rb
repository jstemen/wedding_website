class AddIsConfirmedToInvitationGroup < ActiveRecord::Migration
  def change
    add_column :invitation_groups, :is_confirmed, :boolean, null: false, default: false
  end
end
