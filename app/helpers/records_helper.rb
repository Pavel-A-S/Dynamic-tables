module RecordsHelper

  def cell_name(cell)
                                          # column_name = cell.column.try(:name)
    row_name = cell.row.try(:name)
    if !row_name.blank?                                 # && !column_name.blank?
      "#{row_name}"                                        # " (#{column_name})"
    else
      t(:no_name)
    end
  end

  def set_value(cell, record_id, valid_values)
    if valid_values.blank? || valid_values["#{cell.id}"].blank?
      if cell.integer?
        value = IntegerCell.find_by(cell_id: cell.id, record_id: record_id)
                           .try(:data)
        value = 0 if !value
      elsif cell.decimal?
        value = DecimalCell.find_by(cell_id: cell.id, record_id: record_id)
                           .try(:data)
        value = 0 if !value
      elsif cell.text?
        value = TextCell.find_by(cell_id: cell.id, record_id: record_id)
                        .try(:data)
      else
        value = nil
      end
    else
      value = valid_values["#{cell.id}"]
    end
    return value
  end


  def define_data(record_id, cell)
    if cell.integer?
      IntegerCell.find_by(record_id: record_id, cell_id: cell.id)
    elsif cell.decimal?
      DecimalCell.find_by(record_id: record_id, cell_id: cell.id)
    elsif cell.text?
      TextCell.find_by(record_id: record_id, cell_id: cell.id)
    end
  end



end
