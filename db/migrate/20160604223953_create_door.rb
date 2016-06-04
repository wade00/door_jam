class CreateDoor < ActiveRecord::Migration
  def change
    create_table :doors do |t|
      t.string :status

      t.timestamps
    end
  end
end
