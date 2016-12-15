module CoordinatesHelper

  def available_coordinates(table, coordinate)
    disposition = Coordinate.dispositions[:row]
    table ||= coordinate.table
    coordinates = table.coordinates.where(disposition: disposition)
    values = coordinates.map{ |i| [i.name, i.id] }
    options_for_select(values, coordinate.superior_id)
  end

end
