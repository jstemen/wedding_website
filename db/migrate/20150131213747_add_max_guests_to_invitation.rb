class AddMaxGuestsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :max_guests, :int
  end
end
