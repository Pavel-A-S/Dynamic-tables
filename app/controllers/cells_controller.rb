class CellsController < ApplicationController
  before_action :must_be_administrator
  before_action :set_cell, only: [:show, :edit, :update, :destroy]
  before_action :set_table, only: [:new, :create]

  def index
    @cells = Cell.all
  end

  def show
  end

  def new
    @cell = Cell.new
  end

  def edit
  end

  def create
    @cell = Cell.new(cell_params)
    @cell.table_id = @table.id
    if @cell.save
      flash[:message] = t(:cell_was_created)
      redirect_to table_path(@table)
    else
      flash.now[:alert] = t(:cell_was_not_created)
      render :new
    end
  end

  def update
    if @cell.update(cell_params)
      flash[:message] = t(:cell_was_updated)
      redirect_to @cell
    else
      flash.now[:alert] = t(:cell_was_not_updated)
      render :edit
    end
  end

  def destroy
    if @cell.destroy
      flash[:message] = t(:cell_was_deleted)
      redirect_to table_path(@cell.table)
    else
      if @cell.errors.any?
        flash[:alert] = [t(:cell_was_not_deleted)]
        @cell.errors.map { |k, v| flash[:alert] << v }
      else
        flash[:alert] = t(:cell_was_not_deleted)
      end
      redirect_to table_path(@cell.table)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cell
      @cell = Cell.find(params[:id])
    end

    def set_table
      @table = Table.find_by(id: params[:table_id])
      if @table.blank?
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cell_params
      params.require(:cell).permit(:coordinate_x, :coordinate_y, :cell_type)
    end
end
