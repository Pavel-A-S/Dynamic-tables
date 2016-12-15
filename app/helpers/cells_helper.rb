module CellsHelper

  def available_x_coordinates(table, cell)
    disposition = Coordinate.dispositions[:row]
    table ||= cell.table
    coordinates = table.coordinates.where(disposition: disposition)
    values = coordinates.map{ |i| [i.name, i.id] }
    options_for_select(values, cell.coordinate_x)
  end

  def available_y_coordinates(table, cell)
    disposition = Coordinate.dispositions[:column]
    table ||= cell.table
    coordinates = table.coordinates.where(disposition: disposition)
    values = coordinates.map{ |i| [i.name, i.id] }
    options_for_select(values, cell.coordinate_y)
  end

end
