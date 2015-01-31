class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :code
      t.datetime :time

      t.timestamps
    end
    add_index :invitations, :code, unique: true
  end
end
