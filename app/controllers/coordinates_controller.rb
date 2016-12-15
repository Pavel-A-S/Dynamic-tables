class CoordinatesController < ApplicationController
  before_action :must_be_administrator
  before_action :set_coordinate, only: [:show, :edit, :update, :destroy]
  before_action :set_table, only: [:new, :create]

  def index
    @coordinates = Coordinate.all
  end

  def show
  end

  def new
    @coordinate = Coordinate.new
  end

  def edit
  end

  def create
    @coordinate = Coordinate.new(coordinate_params)
    @coordinate.table_id = @table.id
    if @coordinate.save
      flash[:message] = t(:coordinate_was_created)
      redirect_to table_path(@table)
    else
      flash.now[:alert] = t(:coordinate_was_not_created)
      render :new
    end
  end

  def update
    if @coordinate.update(coordinate_params)
      flash[:message] = t(:coordinate_was_updated)
      redirect_to @coordinate
    else
      flash.now[:alert] = t(:coordinate_was_not_updated)
      render :edit
    end
  end

  def destroy
    if @coordinate.destroy
      flash[:message] = t(:coordinate_was_deleted)
      redirect_to table_path(@coordinate.table)
    else
      if @coordinate.errors.any?
        flash[:alert] = [t(:coordinate_was_not_deleted)]
        @coordinate.errors.map { |k, v| flash[:alert] << v }
      else
        flash[:alert] = t(:coordinate_was_not_deleted)
      end
      redirect_to table_path(@coordinate.table)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coordinate
      @coordinate = Coordinate.find(params[:id])
    end

    def set_table
      @table = Table.find_by(id: params[:table_id])
      if @table.blank?
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coordinate_params
      params.require(:coordinate).permit(:name, :disposition, :superior_id,
                                                              :order)
    end
end
