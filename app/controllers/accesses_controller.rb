class AccessesController < ApplicationController
  before_action :must_be_administrator
  before_action :set_access, only: [:show, :edit, :update, :destroy]

  def index
    @accesses = Access.all
  end

  def show
  end

  def new
    @access = Access.new
  end

  def edit
  end

  def create
    @access = Access.new(access_params)
    if @access.save
      flash[:message] = t(:access_was_created)
      redirect_to @access
    else
      flash.now[:alert] = t(:access_was_not_created)
      render :new
    end
  end

  def update
    if @access.update(access_params)
      flash[:message] = t(:access_was_updated)
      redirect_to @access
    else
      flash.now[:alert] = t(:access_was_not_updated)
      render :edit
    end
  end

  def destroy
    if @access.destroy
      flash[:message] = t(:access_was_deleted)
      redirect_to accesses_path
    else
      flash[:alert] = t(:access_was_not_deleted)
      redirect_to accesses_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access
      @access = Access.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_params
      params.require(:access).permit(:table_id, :user_id)
    end
end
