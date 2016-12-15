class AddSuperiorToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :superior_id, :integer
  end
end
