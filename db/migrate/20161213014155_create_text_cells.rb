class CreateTextCells < ActiveRecord::Migration
  def change
    create_table :text_cells do |t|
      t.integer :record_id
      t.integer :cell_id
      t.text :data

      t.timestamps null: false
    end
  end
end
