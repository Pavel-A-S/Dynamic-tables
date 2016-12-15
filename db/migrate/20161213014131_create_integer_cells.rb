class CreateIntegerCells < ActiveRecord::Migration
  def change
    create_table :integer_cells do |t|
      t.integer :record_id
      t.integer :cell_id
      t.integer :data

      t.timestamps null: false
    end
  end
end
