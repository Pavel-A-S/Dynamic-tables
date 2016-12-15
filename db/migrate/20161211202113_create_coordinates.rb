class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.text :name
      t.integer :disposition
      t.integer :order
      t.integer :table_id

      t.timestamps null: false
    end
  end
end
