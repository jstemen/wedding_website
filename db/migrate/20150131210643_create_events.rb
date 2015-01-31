class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :time

      t.timestamps
    end
  end
end
