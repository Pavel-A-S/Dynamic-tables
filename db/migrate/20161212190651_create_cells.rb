class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :table_id
      t.integer :coordinate_x
      t.integer :coordinate_y
      t.integer :cell_type

      t.timestamps null: false
    end
  end
end
