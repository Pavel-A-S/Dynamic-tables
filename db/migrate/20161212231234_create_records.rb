class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :table_id

      t.timestamps null: false
    end
  end
end
