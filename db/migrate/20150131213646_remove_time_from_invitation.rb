class RemoveTimeFromInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :time, :datetime
  end
end
