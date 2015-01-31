class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address

      t.timestamps
    end
    add_index :guests, :email_address, unique: true
  end
end
