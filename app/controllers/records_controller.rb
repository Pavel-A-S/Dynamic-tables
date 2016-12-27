class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  before_action :set_table, only: [:index, :new, :create]
  before_action :check_access

  def index
    @records = @table.records
  end

  def show
    @coordinates_x = set_coordinates(@record.table_id, :row)
    @coordinates_y = set_coordinates(@record.table_id, :column)
  end

  def new
    @record = Record.new
    @coordinates_x = set_coordinates(@table.id, :row)
    @coordinates_y = set_coordinates(@table.id, :column)
  end

  def edit
    @record.date += @record.date.localtime.utc_offset if @record.date
    @coordinates_x = set_coordinates(@record.table_id, :row)
    @coordinates_y = set_coordinates(@record.table_id, :column)
  end

  def create
    @record = Record.new(record_params)
    @record.table_id = @table.id

    if params[:record].is_a?(Hash) &&
       params[:record][:record_cells].is_a?(Hash) &&
       @record.save
      results = []
      errors = []
      validation = 'ok'
      @valid_values = {}
      params[:record][:record_cells].each do |key, value|
        cell_id = key[%r{\Adata_(\d*)\z}, 1]
        data = value
        @cell = Cell.find_by(id: cell_id)
        type = @cell.try(:cell_type)

        if type == 'integer'
          result = @record.integer_cells.build(cell_id: cell_id, data: data)
        elsif type == 'decimal'
          result = @record.decimal_cells.build(cell_id: cell_id, data: data)
        elsif type == 'text'
          result = @record.text_cells.build(cell_id: cell_id, data: data)
        end

        if result
          if result.valid?
            results << result
            @valid_values["#{@cell.id}"] = result.data
          else
            result.errors.each do |k, v|
              column_name = @cell.column.try(:name) if @cell
              row_name = @cell.row.try(:name) if @cell
              # errors << "#{row_name} (#{column_name}) #{v}"
              errors << "#{row_name} #{v}"
            end
            validation = 'errors'
          end
        end
      end

      if validation == 'errors'
        @record.destroy
        @record = Record.new
        @coordinates_x = set_coordinates(@table.id, :row)
        @coordinates_y = set_coordinates(@table.id, :column)
        errors.each { |e| @record.errors.add(:base, e) }
        flash.now[:alert] = t(:record_was_not_created)
        render :new
      else
        results.each { |r| r.save }
        flash[:message] = t(:record_was_created)
        redirect_to record_path(@record)
      end
    else
      @coordinates_x = set_coordinates(@table.id, :row)
      @coordinates_y = set_coordinates(@table.id, :column)
      flash.now[:alert] = t(:record_was_not_created)
      render :new
    end
  end

  def update
    if params[:record].is_a?(Hash) && params[:record][:record_cells].is_a?(Hash)
      results = []
      errors = []
      validation = 'ok'
      @valid_values = {}
      params[:record][:record_cells].each do |key, value|
        cell_id = key[%r{\Adata_(\d*)\z}, 1]
        data = value
        @cell = Cell.find_by(id: cell_id)
        type = @cell.try(:cell_type)

        if type == 'integer'
          if @integer_cell = @record.integer_cells.find_by(cell_id: cell_id)
            @integer_cell.data = data
            result = @integer_cell
          else
            result = @record.integer_cells.build(cell_id: cell_id, data: data)
          end
        elsif type == 'decimal'
          if @decimal_cell = @record.decimal_cells.find_by(cell_id: cell_id)
            @decimal_cell.data = data
            result = @decimal_cell
          else
            result = @record.decimal_cells.build(cell_id: cell_id, data: data)
          end
        elsif type == 'text'
          if @text_cell = @record.text_cells.find_by(cell_id: cell_id)
            @text_cell.data = data
            result = @text_cell
          else
            result = @record.text_cells.build(cell_id: cell_id, data: data)
          end
        end

        if result
          if result.valid?
            results << result
            @valid_values["#{@cell.id}"] = result.data
          else
            result.errors.each do |k, v|
              column_name = @cell.column.try(:name) if @cell
              row_name = @cell.row.try(:name) if @cell
              # errors << "#{row_name} (#{column_name}) #{v}"
              errors << "#{row_name} #{v}"
            end
            validation = 'errors'
          end
        end
      end

      if validation != 'errors' && @record.update(record_params)
        results.each { |r| r.save }
        flash[:message] = t(:record_was_updated)
        redirect_to @record
      else
        @coordinates_x = set_coordinates(@record.table_id, :row)
        @coordinates_y = set_coordinates(@record.table_id, :column)
        errors.each { |e| @record.errors.add(:base, e) }
        flash.now[:alert] = t(:record_was_not_updated)
        render :edit
      end
    else
      @coordinates_x = set_coordinates(@record.table_id, :row)
      @coordinates_y = set_coordinates(@record.table_id, :column)
      flash.now[:alert] = t(:record_was_not_created)
      render :edit
    end
  end

  def destroy
    if @record.destroy
      flash[:message] = t(:record_was_deleted)
      redirect_to table_records_path(@record.table)
    else
      if @record.errors.any?
        flash[:alert] = [t(:record_was_not_deleted)]
        @record.errors.map { |k, v| flash[:alert] << v }
      else
        flash[:alert] = t(:record_was_not_deleted)
      end
      redirect_to table_records_path(@record.table)
    end
  end

  private
    def check_access
      if !current_user.administrator?
        if @table
          table_id = @table.id
        elsif @record
          table_id = @record.table.id
        else
          table_id = nil
        end
        return if !accessible?(table_id)
      end
    end

    def set_coordinates(table_id, type)
      disposition = Coordinate.dispositions[type]
      Coordinate.where(table_id: table_id, disposition: disposition)
                .order(:order)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    def set_table
      @table = Table.find_by(id: params[:table_id])
      if @table.blank?
        redirect_to root_path
      end
    end

    def record_params
      params.require(:record).permit(:date)
    end
end
