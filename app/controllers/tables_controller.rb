class TablesController < ApplicationController
  before_action :must_be_administrator, except: [:index]
  before_action :set_table, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.administrator?
      @tables = Table.all
    else
      @tables = current_user.tables
    end
  end

  def show
    if not @table.blank?
      @disposition_x = Coordinate.dispositions[:row]
      @disposition_y = Coordinate.dispositions[:column]
      @coordinates_x = @table.coordinates.where(disposition: @disposition_x)
                                         .order(:order)
      @coordinates_y = @table.coordinates.where(disposition: @disposition_y)
                                         .order(:order)
      @cells = @table.cells
    end
  end

  def new
    @table = Table.new
  end

  def edit
  end

  def create
    @table = Table.new(table_params)
    if @table.save
      flash[:message] = t(:table_was_created)
      redirect_to @table
    else
      flash.now[:alert] = t(:table_was_not_created)
      render :new
    end
  end

  def update
    if @table.update(table_params)
      flash[:message] = t(:table_was_updated)
      redirect_to @table
    else
      flash.now[:alert] = t(:table_was_not_updated)
      render :edit
    end
  end

  def destroy
    if @table.destroy
      flash[:message] = t(:table_was_deleted)
      redirect_to tables_path
    else
      flash[:alert] = t(:table_was_not_deleted)
      redirect_to tables_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = Table.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params.require(:table).permit(:name)
    end
end
