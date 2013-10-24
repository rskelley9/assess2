class CreateEventAttendances < ActiveRecord::Migration
  def change
    create_table :event_attendances do |t|
      t.integer :attendee_id,  :null => false
      t.integer :event_id, :null => false

      t.timestamps
    end

    add_index :event_attendances, [:attendee_id, :event_id], :unique => true
    add_index :event_attendances, :event_id
  end
end
